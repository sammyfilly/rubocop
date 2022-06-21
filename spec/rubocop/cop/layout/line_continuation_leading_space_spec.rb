# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Layout::LineContinuationLeadingSpace, :config do
  it 'registers an offense when 2nd line has one leading space' do
    expect_offense(<<~'RUBY')
      'this text is too' \
      ' long'
       ^ Move leading spaces to the end of previous line.
    RUBY
  end

  it 'puts the offense message in correct position also on indented line' do
    expect_offense(<<~'RUBY')
      'this text is too' \
        ' long'
         ^ Move leading spaces to the end of previous line.
    RUBY
  end

  it 'registers an offense when 2nd line has multiple leading spaces' do
    expect_offense(<<~'RUBY')
      'this text contains a lot of' \
      '               spaces'
       ^^^^^^^^^^^^^^^ Move leading spaces to the end of previous line.
    RUBY
  end

  it 'registers offenses when 2nd and 3rd line has leading spaces' do
    expect_offense(<<~'RUBY')
      'this text is too' \
      ' long' \
       ^ Move leading spaces to the end of previous line.
      '  long long'
       ^^ Move leading spaces to the end of previous line.
    RUBY
  end

  it 'registers offense in the right location when 1st line is not the string' do
    expect_offense(<<~'RUBY')
      something_unrelated_to_the_line_continuation_below
      'this text is too' \
      ' long'
       ^ Move leading spaces to the end of previous line.
    RUBY
  end

  it 'marks the correct range when string is a block method argument' do
    expect_offense(<<~'RUBY')
      long_method_name 'this text is too' \
        ' long' do
         ^ Move leading spaces to the end of previous line.
      end
    RUBY
  end

  it 'marks the correct range when string is a positional method argument' do
    expect_offense(<<~'RUBY')
      long_method_name(
        'this text is too' \
        ' long'
         ^ Move leading spaces to the end of previous line.
      )
    RUBY
  end

  describe 'interpolated strings' do
    it 'registers no offense on interpolated string alone' do
      expect_no_offenses(<<~'RUBY')
        "foo #{bar}"
      RUBY
    end

    it 'registers no offense on doubly interpolated string alone' do
      expect_no_offenses(<<~'RUBY')
        "foo #{bar} baz #{qux}"
      RUBY
    end

    it 'registers offenses when 2nd line has leading spaces and 1st line is interpolated' do
      expect_offense(<<~'RUBY')
        "foo #{bar}" \
        ' long'
         ^ Move leading spaces to the end of previous line.
      RUBY
    end

    it 'registers offenses when 2nd line has leading spaces and 2nd line is interpolated' do
      expect_offense(<<~'RUBY')
        'this line is' \
        " #{foo}"
         ^ Move leading spaces to the end of previous line.
      RUBY
    end

    it 'registers no offense for correctly formatted multiline interpolation' do
      expect_no_offenses(<<~'RUBY')
        "five is #{2 + \
          3}"
      RUBY
    end

    it 'registers no offense for correctly formatted multiline interpolated string' do
      expect_no_offenses(<<~'RUBY')
        "foo #{'bar ' \
          'baz'}"
      RUBY
    end

    it 'registers an offense for incorrectly formatted multiline interpolated string' do
      expect_offense(<<~'RUBY')
        "foo #{'bar' \
          ' baz'}"
           ^ Move leading spaces to the end of previous line.
      RUBY
    end
  end
end