Here is a list of items to be done for the whole project, in order.

Highlighting:

1. __Communication between the Eclipse plugin and the backend server__: restablish a proper communication and use of the provided services since the latest changes in the backend. See issues: [a](src/poc/README.md#alignment-with-the-latest-backend-implementation), [b](src/poc/document/README.md#alignment-with-the-latest-backend-implementation), [c](src/poc/editors/README.md#alignment-with-the-latest-backend-implementation).
1. __Highlighting workflow__: check how highlighting update is made, especially against the document update. [See item](src/poc/editors/README.md#highlighting).
1. __Document update__: check that document synchronization between the plugin and the backend works. See [this tutorial](resources/client.md#update-the-content-of-the document) and [this item](ultimate-poc/src/poc/document/README.md#update).

Production/release:

1. __Eclipse Plugin packaging__: be able to launch a backend server from the Eclipse plugin. [See item](README.md#backend-packaging).
1. __Degraded mode__: be able to fallback to a simple raw text editor in case something went wrong, so that the user would not be entirely blocked. See [this item](src/poc/README.md#degraded-mode) and [this issue](src/README.md#fallback-when-backend-launch-failed).
