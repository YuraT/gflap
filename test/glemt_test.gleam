import glemt
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn nfa_even_a_test() {
  glemt.even_a()
  |> glemt.check_string("")
  |> should.equal(True)

  glemt.even_a()
  |> glemt.check_string("a")
  |> should.equal(False)

  glemt.even_a()
  |> glemt.check_string("aa")
  |> should.equal(True)

  glemt.even_a()
  |> glemt.check_string("aaa")
  |> should.equal(False)

  glemt.even_a()
  |> glemt.check_string("aaaa")
  |> should.equal(True)

  glemt.even_a()
  |> glemt.check_string("aab")
  |> should.equal(False)

  glemt.even_a()
  |> glemt.check_string("baabaa")
  |> should.equal(False)
}
