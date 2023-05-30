import gleam/io
import gleam/result.{try}
import gleam_community/ansi
import bella/evaluator
import bella/error
import bella/utils
import bella/project

const usage = "Usage:
  bella create <name>   Create a new project
  bella run             Run the current project
  bella <path>          Run the given file"

pub fn main() {
  case utils.get_args(), get_project() {
    ["create", name, ..], _ -> create_project(name)
    ["run", ..], #(True, Ok(project)) -> run_project(project.name)
    ["run", ..], #(True, Error(msg)) -> error(msg)
    [path, ..], _ -> run_file(path)
    _, _ -> io.println(usage)
  }
}

fn get_project() -> #(Bool, Result(project.Project, String)) {
  case utils.read_file("bella.json") {
    Ok(contents) ->
      case project.decode(contents) {
        Ok(project) -> #(True, Ok(project))
        _ -> #(True, Error("Invalid bella.json"))
      }
    _ -> #(False, Error("Not in a project"))
  }
}

fn run_project(name: String) -> Nil {
  run_file("src/" <> name <> ".bella")
}

fn run_file(path: String) -> Nil {
  case utils.read_file(path) {
    Ok(contents) -> run_str(contents, path)
    _ -> error("I couldn't find the requested file: " <> path)
  }
}

fn run_str(str: String, path: String) -> Nil {
  case evaluator.evaluate_str(str) {
    Error(err) -> error.print_error(err, str, path)
    _ -> Nil
  }
}

fn create_project(name: String) -> Nil {
  case create_project_files(name) {
    Ok(_) -> success("Created project: " <> name)
    _ -> error("Failed to create project")
  }
}

fn create_project_files(name: String) -> Result(String, String) {
  use _ <- try(utils.create_directory("./" <> name <> "/src"))
  use _ <- try(utils.write_file(
    "./" <> name <> "/bella.json",
    project.init(name),
  ))
  utils.write_file(
    "./" <> name <> "/src/" <> name <> ".bella",
    "print('Hello, world!')",
  )
}

// UTILS .......................................................................

fn error(msg: String) -> Nil {
  io.println_error(ansi.red("✕ ") <> msg)
}

fn success(msg: String) -> Nil {
  io.println(ansi.green("✓ ") <> msg)
}
