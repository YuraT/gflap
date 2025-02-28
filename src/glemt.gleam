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
  NFA(states: Set(State), alphabet: Set(AlphabetChar), transition_func: fn(Set(State), AlphabetChar) -> Set(State), init_state: State, accepting_states: Set(State))
}

//pub type DFAViolation {
//  NotAllTransitionsDefined(state: State, missing_chars: Set(AlphabetChar))
//  MultiplePossibleTransitions(state: State, duplicate_chars: Set(AlphabetChar))
//}

pub fn check_string(nfa: NFA, input: String) -> Bool {
  let final_states = input
  |> string.to_graphemes
  |> list.fold(set.from_list([nfa.init_state]), nfa.transition_func)

  !set.is_disjoint(nfa.accepting_states, final_states)
}

pub fn even_a() -> NFA {
  let states = set.from_list([0, 1])
  let alphabet = set.from_list(["a"])
  let transition_func = fn (states, char) {
    states
    |> set.fold(set.new(), fn(n_states, state) {
      case state, char {
        0, "a" -> set.insert(n_states, 1)
        1, "a" -> set.insert(n_states, 0)
        _, _ -> n_states
      }
    })
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
