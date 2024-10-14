from testing import assert_equal, assert_true, assert_false

from openai_rt_client.api import RealtimeAPI
from openai_rt_client.event_handlers import (
    RealtimeEventHandler,
)


alias Payload = String


fn run() raises:
    event_handler = RealtimeEventHandler[Payload]()
    rt_api = RealtimeAPI[__origin_of(event_handler)](event_handler=event_handler, url='ws://localhost:8080', api_key='api_key')
    assert_equal(rt_api.url, 'ws://localhost:8080')
    assert_equal(rt_api.api_key, 'api_key')
    assert_false(rt_api.debug)

