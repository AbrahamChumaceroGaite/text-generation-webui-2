# text-generation-webui
Dockerfile for running oobabooga/text-generation-webui on SaladCloud

This is taken directly from [the official repo](https://github.com/oobabooga/text-generation-webui/blob/main/docker/nvidia/Dockerfile), with the only modification being the installation of socat to enable ipv6 listening, which is required on SaladCloud.
By default, we've set the ipv6 port to 3000. This is the port you should use when setting up salad networking. It can be changed by setting the environment variable `IPV6_PORT`.
You can find swagger docs for the API at `/docs`.
By default, we've set the ipv4 port to 5000, which is the OpenAI compatibility API. It can be changed by setting the environment variable `IPV4_PORT`.
We do not recommend using the actual web ui on salad with a replica count >1, because it is a stateful application, and salad networking routes requests round-robin to each replica.
