from openai_rt_api.event_handlers import RealtimeEventHandler


def test_on_and_dispatch():
    # Test that 'on' handlers are called upon dispatch
    handler = RealtimeEventHandler()
    called = False
    received_event = None

    def callback(event):
        nonlocal called, received_event
        called = True
        received_event = event

    handler.on("test_event", callback)
    handler.dispatch("test_event", {"key": "value"})
    await asyncio.sleep(0.1)  # Allow any asynchronous handlers to run

    assertTrue(called)
    assertEqual(received_event, {"key": "value"})

#    async def test_on_next_and_dispatch(self):
#        # Test that 'on_next' handlers are called only once
#        call_count = 0
#        received_event = None
#
#        def callback(event):
#            nonlocal call_count, received_event
#            call_count += 1
#            received_event = event
#
#        self.handler.on_next("test_event", callback)
#        self.handler.dispatch("test_event", {"key": "first"})
#        self.handler.dispatch("test_event", {"key": "second"})
#        await asyncio.sleep(0.1)
#
#        self.assertEqual(call_count, 1)
#        self.assertEqual(received_event, {"key": "first"})
#
#    async def test_off_specific_handler(self):
#        # Test removing a specific handler
#        called = False
#
#        def callback(event):
#            nonlocal called
#            called = True
#
#        self.handler.on("test_event", callback)
#        self.handler.off("test_event", callback)
#        self.handler.dispatch("test_event", {})
#        await asyncio.sleep(0.1)
#
#        self.assertFalse(called)
#
#    async def test_off_all_handlers(self):
#        # Test removing all handlers for an event
#        call_count = 0
#
#        def callback1(event):
#            nonlocal call_count
#            call_count += 1
#
#        def callback2(event):
#            nonlocal call_count
#            call_count += 1
#
#        self.handler.on("test_event", callback1)
#        self.handler.on("test_event", callback2)
#        self.handler.off("test_event")
#        self.handler.dispatch("test_event", {})
#        await asyncio.sleep(0.1)
#
#        self.assertEqual(call_count, 0)
#
#    async def test_wait_for_next_event(self):
#        # Test that wait_for_next correctly waits for an event
#        async def dispatcher():
#            await asyncio.sleep(0.1)
#            self.handler.dispatch("test_event", {"data": 123})
#
#        asyncio.create_task(dispatcher())
#        event = await self.handler.wait_for_next("test_event", timeout=1000)
#        self.assertIsNotNone(event)
#        self.assertEqual(event, {"data": 123})
#
#    async def test_wait_for_next_timeout(self):
#        # Test that wait_for_next returns None on timeout
#        event = await self.handler.wait_for_next("test_event", timeout=100)
#        self.assertIsNone(event)
#
#    async def test_clear_event_handlers(self):
#        # Test that all handlers are cleared
#        called = False
#
#        def callback(event):
#            nonlocal called
#            called = True
#
#        self.handler.on("test_event", callback)
#        self.handler.clear_event_handlers()
#        self.handler.dispatch("test_event", {})
#        await asyncio.sleep(0.1)
#
#        self.assertFalse(called)
#
#    async def test_off_nonexistent_handler_raises(self):
#        # Test that removing a non-existent handler raises an error
#        def callback(event):
#            pass
#
#        with self.assertRaises(ValueError) as context:
#            self.handler.off("test_event", callback)
#
#        self.assertIn('Could not turn off specified event listener for "test_event"', str(context.exception))
#
#    async def test_off_next_specific_handler(self):
#        # Test removing a specific on_next handler
#        call_count = 0
#
#        def callback(event):
#            nonlocal call_count
#            call_count += 1
#
#        self.handler.on_next("test_event", callback)
#        self.handler.off_next("test_event", callback)
#        self.handler.dispatch("test_event", {})
#        await asyncio.sleep(0.1)
#
#        self.assertEqual(call_count, 0)
#
#    async def test_off_next_all_handlers(self):
#        # Test removing all on_next handlers for an event
#        call_count = 0
#
#        def callback1(event):
#            nonlocal call_count
#            call_count += 1
#
#        def callback2(event):
#            nonlocal call_count
#            call_count += 1
#
#        self.handler.on_next("test_event", callback1)
#        self.handler.on_next("test_event", callback2)
#        self.handler.off_next("test_event")
#        self.handler.dispatch("test_event", {})
#        await asyncio.sleep(0.1)
#
#        self.assertEqual(call_count, 0)
#
#    async def test_dispatch_order(self):
#        # Test that 'on' handlers are called before 'on_next' handlers
#        call_order = []
#
#        def on_callback(event):
#            call_order.append("on")
#
#        def on_next_callback(event):
#            call_order.append("on_next")
#
#        self.handler.on("test_event", on_callback)
#        self.handler.on_next("test_event", on_next_callback)
#        self.handler.dispatch("test_event", {})
#        await asyncio.sleep(0.1)
#
#        self.assertEqual(call_order, ["on", "on_next"])
#
#    async def test_multiple_handlers(self):
#        # Test multiple handlers for the same event
#        call_count = 0
#
#        def callback1(event):
#            nonlocal call_count
#            call_count += 1
#
#        def callback2(event):
#            nonlocal call_count
#            call_count += 1
#
#        self.handler.on("test_event", callback1)
#        self.handler.on("test_event", callback2)
#        self.handler.dispatch("test_event", {})
#        await asyncio.sleep(0.1)
#
#        self.assertEqual(call_count, 2)
#
#    async def test_wait_for_next_multiple_waiters(self):
#        # Test multiple wait_for_next calls for the same event
#        async def waiter(identifier, results):
#            event = await self.handler.wait_for_next("test_event")
#            results.append((identifier, event))
#
#        results = []
#        asyncio.create_task(waiter(1, results))
#        asyncio.create_task(waiter(2, results))
#        await asyncio.sleep(0.1)
#        self.handler.dispatch("test_event", {"info": "test"})
#        await asyncio.sleep(0.1)
#
#        self.assertEqual(len(results), 2)
#        for identifier, event in results:
#            self.assertEqual(event, {"info": "test"})


fn run() raises:
    test_on_and_dispatch()