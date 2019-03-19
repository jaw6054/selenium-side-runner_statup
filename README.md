# selenium-side-runner_statup

selenium-side-runner to run .side files on a selenium cluster.

## Configuration

This image needs 2 environment variables and 2 volumes:

### Variables

There is no authentication mechanism in place. Use kubernetes network policy or similar
to secure the hub

| Variable	| Comment	 	|
| ------------- | ---------------------	|
| HUB_ADDRESS	| URL of the hub	|
| HUB_PORT	| port of the URL	|

### Volumes

The command `selenium-side-runner` is run as user with the UID **654339**. The directories
must be readable (`/sides`) and writable (`/out`) for that UID.

| Volume	| Comment		|
| ------------- | --------------------- |
| /sides	| Directory with .side files to be tested.<br>The image uses `*.side` to select all files,<br>so if you need to execute them in a specific<br>order you have to name them with that<br>sort order in mind. |
| /out		| Output will be saved here |

