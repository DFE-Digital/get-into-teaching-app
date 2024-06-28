# Events Portal

The teaching events displayed on the website are pulled from the Dynamics CRM via the GiT API. The events team manage these events via the Get into Teaching website, which has an 'internal events portal'.

The portal can be access at the `/internal/events` path and you will be prompted to login using basic auth credentials, which can be found in the appropriate keyvault for the environment you are looking at (e.g. `make test print-app-secrets`). You will need to login with a user that has either the `author` or `publisher` role (authors can create events but not publish them, publishers can create and publish).

The portal can be useful in dev/test environments for adding teaching events to test a scenario. Note that if you do this you should make it clear in the title that the event is a test event to avoid it being accidently migrated through to production.
