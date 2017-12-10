
defmodule Passphrase do

  def valid?(line) do
    words = line |> String.split
    count = words |> Enum.count
    unique_count = words
      |> Enum.uniq
      |> Enum.count
    count == unique_count
  end

  def no_anagrams?(line) do
    words = line
      |> String.split
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&Enum.sort/1)
    count = words |> Enum.count
    unique_count = words |> Enum.uniq |> Enum.count
    count == unique_count
  end

end

passwords = File.stream!("day4.txt")
num_passwords = passwords |> Enum.count

valid_passwords = passwords
  |> Stream.filter(&Passphrase.valid?/1)
  |> Enum.count
IO.puts "First star: #{valid_passwords} out of #{num_passwords} are valid."

no_anagrams = passwords
  |> Stream.filter(&Passphrase.no_anagrams?/1)
  |> Enum.count
IO.puts "Second star: #{no_anagrams} out of #{num_passwords} are valid and not anagrams."
