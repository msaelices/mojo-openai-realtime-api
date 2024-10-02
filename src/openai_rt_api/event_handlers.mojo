from time import sleep
from collections import Dict, Optional

alias PayloadType = EqualityComparableCollectionElement


async fn ms_sleep(t: Int) -> None:
    """
    Asynchronously sleeps for `t` milliseconds.

    Args:
        t: Time to sleep in milliseconds.
    """
    sleep(t / 1000.0)


@value
struct EventHandlerCallback[
    P: PayloadType,
](EqualityComparableCollectionElement):
    """
    A simple callback class.
    """
    alias event_type = Dict[String, P]
    var name: String
    var callback: fn (Self.event_type) -> None

    fn __init__(inout self, name: String, callback: fn (Self.event_type) -> None) -> None:
        """
        Initializes a new instance of Callback.

        Args:
            name: The name of the callback.
            callback: The callback function.
        """
        self.name = name
        self.callback = callback

    fn __call__(self, event: Self.event_type) -> None:
        """
        Calls the callback function.
        """
        self.callback(event)
    
    fn __eq__(self, other: Self) -> Bool:
        """
        Checks if two Callback instances are equal.

        Args:
            other: The other Callback instance.
        
        Returns:
            True if the instances are equal, False otherwise.
        """
        return self.name == other.name
    
    fn __ne__(self, other: Self) -> Bool:
        """
        Checks if two Callback instances are not equal.

        Args:
            other: The other Callback instance.
        
        Returns:
            True if the instances are not equal, False otherwise.
        """
        return self.name != other.name


struct RealtimeEventHandler[P: PayloadType]:
    """
    Inherited struct for RealtimeAPI and RealtimeClient.
    Adds basic event handling capabilities.
    """
    # Useful type aliases 
    alias callback_type = EventHandlerCallback[P]
    alias event_type = Self.callback_type.event_type
    alias callback_list_type = List[Self.callback_type]

    # Type definition for event handler callbacks
    var event_handlers: Dict[String, Self.callback_list_type]
    var next_event_handlers: Dict[String, Self.callback_list_type]

    fn __init__(inout self) -> None:
        """
        Initializes a new instance of RealtimeEventHandler.
        """
        self.event_handlers = Dict[String, Self.callback_list_type]()
        self.next_event_handlers = Dict[String, Self.callback_list_type]()

    fn clear_event_handlers(inout self) -> Bool:
        """
        Clears all event handlers.

        Returns:
            Always returns True.
        """
        self.event_handlers.clear()
        self.next_event_handlers.clear()
        return True

    fn on[callback: EventHandlerCallback[P]](inout self, event_name: String) raises -> EventHandlerCallback[P]:
        """
        Registers a callback for a specific event.

        Parameters:
            callback: The callback function to execute when the event is dispatched.

        Args:
            event_name: The name of the event to listen to.
        
        Returns:
            The callback function.
        """
        if event_name not in self.event_handlers:
            self.event_handlers[event_name] = Self.callback_list_type()
        self.event_handlers[event_name].append(callback)
        return callback

    fn on_next[callback: EventHandlerCallback[P]](self, event_name: String) raises -> None:
        """
        Registers a callback for the next occurrence of a specific event.

        Parameters:
            callback: The callback function to execute when the event is dispatched.

        Args:
            event_name: The name of the event to listen to.
        """
        pass
        # TODO: Why is not working?
        # if event_name not in self.next_event_handlers:
        #     self.next_event_handlers[event_name] = Self.callback_list_type()
        # self.next_event_handlers[event_name].append(callback)

    fn off[callback: Self.callback_type](inout self, event_name: String) raises -> Bool:
        """
        Removes one callback for a specific event.

        Parameters:
            callback: The specific callback to remove (optional).

        Args:
            event_name: The name of the event.
        
        Returns:
            Always returns True.
        
        Raises:
            ValueError: If the specified callback is not found.
        """
        handlers = self.event_handlers.get(event_name, Self.callback_list_type())
        if handlers:
            try:
                # TODO: use list.remove() when implemented in Mojo
                _ = handlers.pop(handlers.index(value=callback))
            # TODO: Use proper exception handling when implemented in Mojo
            except:
                # TODO: use f-strings when supported in Mojo
                raise Error('ValueError: Could not turn off specified event listener: not found as a listener for ' + event_name)
        else:
            _ = self.event_handlers.pop(event_name)
        return True

    fn off_next[callback: Self.callback_type](inout self, event_name: String) raises -> Bool:
        """
        Removes one callback for an specific next event.

        Parameters:
            callback: The specific callback to remove (optional).

        Args:
            event_name: The name of the event.
        
        Returns:
            Always returns True.
        
        Raises:
            ValueError: If the specified callback is not found.
        """
        handlers = self.next_event_handlers.get(event_name, Self.callback_list_type())
        if handlers:
            try:
                # TODO: use list.remove() when implemented in Mojo
                _ = handlers.pop(handlers.index(value=callback))
            # TODO: Use proper exception handling when implemented in Mojo
            except:
                # TODO: use f-strings when supported in Mojo
                raise Error(
                    'Could not turn off specified next event listener: not found as a listener for ' + event_name
                )
        else:
            _ = self.next_event_handlers.pop(event_name)
        return True

    fn off_all(inout self, event_name: String) raises -> Bool:
        """
        Removes all event listeners for a specific event.

        Args:
            event_name: The name of the event.
        
        Returns:
            Always returns True.
        """
        _ = self.event_handlers.pop(event_name)
        return True

    fn off_next_all(inout self, event_name: String) raises -> Bool:
        """
        Removes all event listeners for a specific next event.

        Args:
            event_name: The name of the event.
        
        Returns:
            Always returns True.
        """
        _ = self.next_event_handlers.pop(event_name)
        return True

    # TODO: Figure out how to implement this in Mojo
    # async fn wait_for_next(self, event_name: String, timeout: Optional[Int] = None) -> Optional[PayloadType]:
    #     """
    #     Waits for the next occurrence of a specific event and returns its payload.
    #     If a timeout is provided and the event does not occur within the timeout period, returns None.

    #     Args:
    #         event_name: The name of the event to wait for.
    #         timeout: Timeout in milliseconds (optional).
    #     
    #     Returns:
    #         The event payload as a dictionary, or None if timed out.
    #     """
    #     loop = asyncio.get_event_loop()
    #     future = loop.create_future()

    #     fn handler(event: Dict[String, Any]) -> None:
    #         if not future.done():
    #             future.set_result(event)

    #     self.on_next(event_name, handler)

    #     try:
    #         if timeout is not None:
    #             result = await asyncio.wait_for(future, timeout=timeout / 1000.0)
    #         else:
    #             result = await future
    #         return result
    #     except asyncio.TimeoutError:
    #         self.off_next(event_name, handler)
    #         return None

    fn dispatch(inout self, event_name: String, event: Self.event_type) raises -> Bool:
        """
        Dispatches an event to all registered handlers.
        Executes .on() event handlers before .on_next() handlers.

        :param event_name: The name of the event to dispatch.
        :param event: The event payload.
        :return: Always returns True.
        """
        # Execute regular event handlers
        handlers = self.event_handlers.get(event_name, Self.callback_list_type())
        for handler_ref in handlers:
            handler = handler_ref[]
            handler(event)

        # Execute next event handlers
        next_handlers = self.next_event_handlers.get(event_name, Self.callback_list_type())
        for handler_ref in next_handlers:
            handler = handler_ref[]
            handler(event)

        # Clear next event handlers after dispatching
        _ = self.next_event_handlers.pop(event_name)
        return True
