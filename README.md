# Stevedore Demostration

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

The Stevedore demonstration is a simple project that demonstrates how to use Stevedore to build and promote Docker images.

The project is provided by a Makefile that guides the user through the demonstration. The demonstration starts an environment with a Docker registry and a Git server, as well as a container that runs Stevedore. All the actions are performed by the Stevedore container, which is used to build and promote Docker images.

You can run the demonstration on your local machine by executing the following commands:

- Start the environment with the required services:

```bash
make start
```

- Run the demonstration:

```bash
make demo
```

You can also find additional examples of how to use Stevedore in the [examples](https://gostevedore.github.io/docs/examples/) section of the Stevedore documentation.

## Contributing

Thank you for your interest in contributing to Stevedore! All contributions are welcome, whether they are bug reports, feature requests, or code contributions. Please read the [contributor's guide in Stevedore documentation](https://gostevedore.github.io/docs/contribution-guidelines/) to know more about how to contribute.

## License

Stevedore is licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE) for the full license text.
