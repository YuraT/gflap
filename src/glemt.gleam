import gleam/dict.{type Dict}
import gleam/io
import gleam/list
import gleam/result
import gleam/set.{type Set}
import gleam/string

pub type State =
  Int

pub type AlphabetChar =
  String

pub type NFATransitionKey =
  #(State, AlphabetChar)

pub type NFATransitionFunction =
  Dict(NFATransitionKey, Set(State))

pub type NFAError {
  NoTransition
}

pub type NFA {
  NFA(
    states: Set(State),
    alphabet: Set(AlphabetChar),
    transitions: NFATransitionFunction,
    init_state: State,
    accepting_states: Set(State),
  )
}

pub type DFAViolation {
  NotAllTransitionsDefined(state: State, missing_chars: Set(AlphabetChar))
  MultiplePossibleTransitions(state: State, duplicate_chars: Set(AlphabetChar))
}

pub fn is_dfa(nfa: NFA) -> Result(Nil, List(DFAViolation)) {
  let violations =
    nfa.states
    |> set.map(fn(state) {
      let missing_transitions =
        nfa.alphabet
        |> set.filter(fn(char) {
          nfa.transitions
          |> dict.get(#(state, char))
          |> result.unwrap(set.new())
          |> set.is_empty
        })

      let multi_transitions =
        nfa.transitions
        |> dict.filter(fn(_key, val) { set.size(val) > 1 })
        |> dict.keys
        |> list.map(fn(transition_key) { transition_key.1 })
        |> set.from_list

      let missing_transitions = case set.size(missing_transitions) {
        count if count > 0 -> [
          NotAllTransitionsDefined(state, missing_transitions),
        ]
        _ -> []
      }

      let multi_transitions = case set.size(multi_transitions) {
        count if count > 0 -> [
          MultiplePossibleTransitions(state, multi_transitions),
        ]
        _ -> []
      }

      list.append(missing_transitions, multi_transitions)
    })
    |> set.to_list
    |> list.flatten

  case list.length(violations) {
    count if count > 0 -> Error(violations)
    _ -> Ok(Nil)
  }
}

fn exec_transition(
  transitions: Dict(#(State, AlphabetChar), Set(State)),
  states: Set(State),
  char: AlphabetChar,
) -> Set(State) {
  states
  |> set.filter(fn(state) { dict.has_key(transitions, #(state, char)) })
  |> set.fold(set.new(), fn(new_states, state) {
    new_states
    |> set.union(
      transitions
      |> dict.get(#(state, char))
      |> result.unwrap(set.new()),
    )
  })
}

pub fn check_string(nfa: NFA, input: String) -> Bool {
  let final_states =
    input
    |> string.to_graphemes
    |> list.fold(set.from_list([nfa.init_state]), fn(states, char) {
      exec_transition(nfa.transitions, states, char)
    })

  !set.is_disjoint(nfa.accepting_states, final_states)
}

pub fn even_a() -> NFA {
  let states = set.from_list([0, 1])
  let alphabet = set.from_list(["a"])
  let transitions =
    dict.from_list([
      #(#(0, "a"), set.from_list([1])),
      #(#(1, "a"), set.from_list([0])),
    ])
  let init_state = 0
  let accepting_states = set.from_list([0])
  NFA(states:, alphabet:, transitions:, init_state:, accepting_states:)
}

pub fn ends_with_b() -> NFA {
  let states = set.from_list([0, 1, 2])
  let alphabet = set.from_list(["a", "b"])
  let transitions =
    dict.from_list([
      #(#(0, "a"), set.from_list([1])),
      #(#(0, "b"), set.from_list([0, 2])),
      #(#(1, "a"), set.from_list([1])),
      #(#(1, "b"), set.from_list([2])),
      // #(#(2, "a"), set.from_list([0])),
      // #(#(2, "b"), set.from_list([1])),
    ])
  let init_state = 0
  let accepting_states = set.from_list([0, 2])
  NFA(states:, alphabet:, transitions:, init_state:, accepting_states:)
}

pub fn main() {
  io.println("Hello from glemt!")

  let automaton = even_a()
  let _ = io.debug(is_dfa(automaton))
  io.debug(check_string(automaton, ""))
  io.debug(check_string(automaton, "a"))
  io.debug(check_string(automaton, "aa"))
  io.debug(check_string(automaton, "aaab"))

  let automaton = ends_with_b()
  io.debug(is_dfa(automaton))
  io.debug(check_string(automaton, ""))
  io.debug(check_string(automaton, "a"))
  io.debug(check_string(automaton, "aa"))
  io.debug(check_string(automaton, "aaaaaa"))
  io.debug(check_string(automaton, "aaabaaa"))
  io.debug(check_string(automaton, "bbbbbaab"))
  io.debug(check_string(automaton, "abaabaaab"))
}
