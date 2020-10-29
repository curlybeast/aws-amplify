# Docker Image for use with Amplify

## Requirements

These are according to the [Getting Started Documentation](https://docs.amplify.aws/start/getting-started/installation/q/integration/angular) for Angular:

- Node.js v10.x or later
- npm v5.x or later
- git v2.14.1 or later

## Documentation

At the time of writing, the [Amplify Console Custom Build Image documentation](https://docs.aws.amazon.com/amplify/latest/userguide/custom-build-image.html) about custom build images doesn't give a lot of info about the requirements and about the environment.

## Building / Running Docker Image

Build with:

```
$ docker build --build-arg NAME="Martyn Russell" --build-arg EMAIL="martyn.russell@company.com" .
```

**IMPORTANT**: Make sure the `REAL_NAME` and `EMAIL_ADDRESS` are set correctly. This can be done by either changing the `Dockerfile` or by passing them in.

This generates a hash which can be run with:

```
$ docker run -it <hash>
```

**IMPORTANT**: When using AWS credentials from the host machine, there is a volume (`~/.aws`) that can be mounted to allow for persistent configuration between containers.

## Amplify Setup

See the [documentation](https://docs.amplify.aws/start/getting-started/installation/q/integration/angular) for more details on this process:


```
$ amplify configure
...
$ cd /path/to/shared/volume
$ npx ng new amplify-app
? Would you like to add Angular routing? Yes
? Which stylesheet format would you like to use? CSS
CREATE amplify-app/README.md (1019 bytes)
CREATE amplify-app/.editorconfig (274 bytes)
...
✔ Packages installed successfully.
    Successfully initialized git.
$
```

Next we get into our new project and fix up Angular 6+ Support:

```
$ cd amplify-app
$ cat <<EOF > src/polyfills.ts
(window as any).global = window;
(window as any).process = {
  env: { DEBUG: undefined },
};
EOF
```

Add Amplify backend:

```
$ amplify init
Note: It is recommended to run this command from the root of your app directory
? Enter a name for the project amplifyapp
? Enter a name for the environment dev
? Choose your default editor: Visual Studio Code
? Choose the type of app that you're building javascript
Please tell us about your project
? What javascript framework are you using angular
? Source Directory Path:  src
? Distribution Directory Path: dist/amplify-app
? Build Command:  npm run-script build
? Start Command: ng serve
Using default provider  awscloudformation

For more information on AWS Profiles, see:
https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html

? Do you want to use an AWS profile? Yes
...
```

Add Amplify frontend:

```
$ npm install --save aws-amplify @aws-amplify/ui-angular
...
```

## Starting Angular

Start the frontend with:

```
$ npm start
```

**IMPORTANT**: When running on MacOS, the host needed to change from `localhost` to `0.0.0.0` because `localhost` in the container (the default `host`) has no route to it from the host operating system. The security warnings can be ignored because it's running in an isolated environment.

Changing the start command permanently can be done by updating the `pacakge.json` file:

```
{
  "scripts": {
    "ng": "ng",
    "start": "ng serve --host 0.0.0.0",
    ...
  }
}
```

