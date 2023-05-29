# Bella programming language

![Bella language logo](assets/Bella-language.png)

Bella is a simple functional programming language, written in [Gleam](https://gleam.run). Still very much a work-in-progress. 🚧

## Using Bella

[Download](https://github.com/MystPi/bella/releases) the appropriate executable for your system and add it to PATH, then you can:

- Try out the [examples](/examples/)
  ```sh
  bella ./examples/hello_world.bella
  ```
- Create a project
  ```sh
  bella create my_project
  cd my_project
  bella run
  ```

## Developing

You will need:

- Gleam
- Node.js/Deno _(This is Gleam's target runtime)_
- This repo

```sh
# Using Node.js
gleam run ./examples/hello_world.bella

# Using Deno
gleam run --runtime deno ./examples/hello_world.bella
```

Creating a Bella executable requires Deno.

```sh
# Build
gleam clean && gleam build

# Compile
deno compile --unstable --allow-all ./build/dev/javascript/bella/main.mjs -o ./build/bella

# Run
./build/bella ./examples/countdown.bella
```
