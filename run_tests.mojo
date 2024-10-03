from tests import (
    test_api,
    test_audio,
    test_client,
    test_event_handlers,
    test_uuid,
)


def main():
    test_api.run()
    test_audio.run()
    test_client.run()
    # TODO: Fix the closures issues in the event handlers tests
    # test_event_handlers.run()
    test_uuid.run()
