from collections import Dict, Optional
from testing import assert_equal, assert_true

from openai_rt_client.event_handlers import (
    EventHandlerCallback,
    RealtimeEventHandler,
)

alias EventPayload = String
alias Event = Dict[String, EventPayload]


fn test_on_and_dispatch() raises:
    # Test that 'on' handlers are called upon dispatch
    var handler = RealtimeEventHandler[EventPayload]()
    var count = 1
    var received_event = Optional[Event]()

    # TODO: Change to capturing fn once Mojo supports it
    # fn count_callback(event: Event) capturing -> None:
    fn count_callback(event: Event) -> None:
        count += 1
        received_event = event
    
    # If using capturing closures, we receive the following error in following sentence:
    # error: TODO: capturing closures cannot be materialized as runtime values
    event_handler_callback = EventHandlerCallback[EventPayload](
        'count',
        count_callback,
    )
    handler.on('test_event', event_handler_callback)

    event= Event()
    event['key'] = 'value'
    _ = handler.dispatch('test_event', event)

    assert_equal(count, 2)
    assert_true(received_event)
    assert_equal(received_event.value()['key'], event['key'])


fn run() raises:
    test_on_and_dispatch()
