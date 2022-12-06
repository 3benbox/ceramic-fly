# Ceramic fly.io

This repo provides an example template for launching a [ceramic network](https://ceramic.network/) node on the the [fly.io](https://fly.io/) platform that is suitable for [ComposeDB](https://composedb.js.org/)

## Administrivia

First, lets clone the repo.

```
git clone https://github.com/3benbox/ceramic-fly
```

Then we'll need the `fly` cli installed. Refer to your platform docs here https://fly.io/docs/hands-on/install-flyctl/, but generally this should work.

```
curl -L https://fly.io/install.sh | sh
```

Lastly, let's use the cli to signup if you do not yet have an account.

```
flyctl auth signup
```

## Usage

Before deploying our node, a few words about the fly.io platform. It's designed to build and run Docker containers as virtual machines on fly.io infrastrucure.

Our Ceramic node will be deployed as a fly.io "application" which belongs to a fly.io organization.

The organization is a billing, network, and security boundry. We can invite additional team members to the org and deploy additional apps to the organization. The org's apps have visibility and discovery in the org for composiblity. Scaling happens at the app level.

Lets pick an org and app name. Names belong to a global namespace, so they must be unique.

```
APP_ORG=ceramic-fly-0x$(openssl rand -hex 4)
APP_NAME=${APP_ORG}-node
```

Now create the org in fly.io
```
fly orgs create $APP_ORG
```

One last administration task, we have to add billing to the account. Navigate to https://fly.io/dashboard/, select the new organization and add a credit card to the billing section.

Next, we'll create the app. This is command is going to deploy the app to the `lax` regions, which is fine for the example.

```
flyctl launch --name=$APP_NAME \
  --org $APP_ORG \
  --copy-config \
  --region lax \
  --auto-confirm \
  --no-deploy
```

The app needs a persistant volume so we don't lose our ceramic node data. Create it like:

```
fly volumes create ceramic_data \
  --app $APP_NAME \
  --region lax \
  --size 15
```

Ready to go, let's deploy!
```
flyctl deploy
```

Check the status of the node with this command, it should return the url for the app.
```
fly status
```

Check the logs of the node like
```
fly logs
```

What, the node had an error and restarted?!?   
No worries, give it some more memory like:
```
fly scale memory 1024
```

Wait for the the new app instance to launch and the old one to terminate and check the status again.

```
fly status
```

### Is it working?

You can verify the cermic node is running and available by querying the node health endpoint.

```
curl http://$APP_NAME.fly.dev:7007/api/v0/node/healthcheck
Alive!
```


### Making ceramic daemon changes

You can check `daemon.config.json` file for the configuration of the node. You may want to change the `http-api.admin-dids` or `indexing.modeling` values first. 

Edit the `daemon.config.json` file and run

```
fly deploy
```
:raised_hands: