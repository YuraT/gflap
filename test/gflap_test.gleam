import gflap
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn nfa_even_a_test() {
  gflap.even_a()
  |> gflap.check_string("")
  |> should.equal(True)

  gflap.even_a()
  |> gflap.check_string("a")
  |> should.equal(False)

  gflap.even_a()
  |> gflap.check_string("aa")
  |> should.equal(True)

  gflap.even_a()
  |> gflap.check_string("aaa")
  |> should.equal(False)

  gflap.even_a()
  |> gflap.check_string("aaaa")
  |> should.equal(True)

  gflap.even_a()
  |> gflap.check_string("aab")
  |> should.equal(False)

  gflap.even_a()
  |> gflap.check_string("baabaa")
  |> should.equal(False)
}
