package RT::CustomFieldValues::Rome;

# define class inheritance
use base qw(RT::CustomFieldValues::External);

# admin friendly description, the default valuse is the name of the class
sub SourceDescription {
  return 'Rome';
}

# actual values provider method
sub ExternalValues {
  # return reference to array ([])
  return [
      # each element of the array is a reference to hash that describe a value
      # possible keys are name, description, sortorder, and category
      { name => 'rome1', description => 'external value', sortorder => 1, },
      { name => 'rome2', description => 'another external value', sortorder => 2, },
  ];
}

1; # don't forget to return some true value