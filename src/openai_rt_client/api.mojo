from collections import Optional
from memory import Pointer, Reference
from python import Python, PythonObject

from openai_rt_client.event_handlers import PayloadType, RealtimeEventHandler


@value
struct RealtimeAPI[
    is_mutable: Bool,
    P: PayloadType,
    //,
    life: Origin[is_mutable].type,
]:
    """RealtimeAPI is a struct that holds the configuration for the Realtime API client."""

    #var event_handler_ref: Pointer[RealtimeEventHandler[P], life]
    var event_handler: RealtimeEventHandler[P]
    """The event handler to use for processing events."""
    var url: String
    """The URL of the Realtime API."""
    var api_key: String
    """The API key to use for authentication."""
    var debug: Bool
    """Whether to enable debug mode."""
    var ws: Optional[PythonObject]
    """WebSocket connection."""

    def __init__(inout self, event_handler: RealtimeEventHandler[P], url: String, api_key: String, debug: Bool = False):
        """
        RealtimeAPI is a struct that holds the configuration for the Realtime API client.

        Args:
            event_handler: The event handler to use for processing events.
            url: The URL of the Realtime API.
            api_key: The API key to use for authentication.
            debug: Whether to enable debug mode.
        """
        self.event_handler = event_handler
        self.url = url
        self.api_key = api_key
        self.debug = debug
        self.ws = Optional[PythonObject](None)

