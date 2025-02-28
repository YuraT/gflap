import gleam/list
import gleam/string
import gleam/set.{type Set}
import gleam/io

//pub type State {
//  State(Int)
//}

pub type State = Int

//pub type AlphabetChar {
//  AlphabetChar(String)
//}

pub type AlphabetChar = String

pub type NFAError {
  NoTransition
}

pub type NFA {
  NFA(states: Set(State), alphabet: Set(AlphabetChar), transition_func: fn(State, AlphabetChar) -> Result(State, NFAError), init_state: State, accepting_states: Set(State))
}

//pub type DFAViolation {
//  NotAllTransitionsDefined
//  MultiplePossibleTransitions
//}

pub fn check_string(automaton: NFA, input: String) -> Bool {
  let result = input
  |> string.to_graphemes
  |> list.try_fold(automaton.init_state, automaton.transition_func)

  case result {
    Ok(state) -> set.contains(automaton.accepting_states, state)
    Error(_) -> False
  }
}

pub fn even_a() -> NFA {
  let states = set.from_list([0, 1])
  let alphabet = set.from_list(["a"])
  let transition_func = fn (state: State, char: AlphabetChar) -> Result(State, NFAError) {
    case state, char {
      0, "a" -> Ok(1)
      1, "a" -> Ok(0)
      _, _ -> Error(NoTransition)
    }
  }
  let init_state = 0
  let accepting_states = set.from_list([0])
  NFA(states:, alphabet:, transition_func:, init_state:, accepting_states:)
}

pub fn main() {
  io.println("Hello from glemt!")

  let automaton = even_a()
  io.debug(check_string(automaton, ""))
  io.debug(check_string(automaton, "a"))
  io.debug(check_string(automaton, "aa"))
  io.debug(check_string(automaton, "aaab"))
}
