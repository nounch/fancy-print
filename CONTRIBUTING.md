# Contributing

When adding a new output type, do this:

1. Update the server to support the new type.
2. Update the front end to support the new type.
3. Add a method for the new type to the client (be sure to also attach a
   method to `Object' which acts as a proxy for the cient method).
4. Add a command line option to the CLI.

Model the new output type according to the existing ones (e.g. provide a
`--msg` option for the command line interface and a `:msg` option for the
client).
