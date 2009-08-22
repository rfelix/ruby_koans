require 'edgecase'

class AboutNil < EdgeCase::Koan
  def test_nil_is_an_object
    assert nil.is_a?(Object), "Unlike NULL in other languages"
  end

  def test_you_dont_get_null_pointer_errors_when_calling_methods_on_nil
    #
    #  What is the Exception that is thrown when you call a method that
    #  does not exist?  
    #
    #  Hint:  launch irb and try the code in the block below.  
    # 
    #  Don't be confused by the code below yet.  It's using blocks 
    #  which are explained later on in about_blocks.rb.  For now,
    #  think about it like running nil.some_method_nil_doesnt_know_about
    #  in a sandbox and catching the error class into the exception
    #  variable.  
    #
    exception = assert_raise(NoMethodError) do
      nil.some_method_nil_doesnt_know_about
    end
    
    # 
    #  What is the error message itself? What substring or pattern could 
    #  you test against in order to have a good idea what the string is?
    #  
    assert_match /undefined method `(\w|\d)+' for nil:NilClass/, exception.message
  end

  def test_nil_has_a_few_methods_defined_on_it
    assert_equal true, nil.nil?
    assert_equal "", nil.to_s
    assert_equal "nil", nil.inspect

    # THINK ABOUT IT:
    #
    # Is it better to use
    #    obj.nil?
    # or
    #    obj == nil
    # Why?
    
    # My answer:
    # It's better to use obj.nil? because...
    # (link: http://kentreis.wordpress.com/2007/02/08/identity-and-equality-in-ruby-and-smalltalk/)
    # it seems to peform a little bit better than ==, plus it's more idiomatic
    # (check Ruby/Playgroud/misc/nil benchmar.rb)
  end

end
