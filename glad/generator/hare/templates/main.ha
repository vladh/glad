{% set ctx_name = feature_set.name | capitalize %}
// Types
{% include 'types/' + spec.name + '.ha' ignore missing with context %}

// Constants
{% for enum in feature_set.enums %}
export def {{ enum.name|no_prefix }}: {{ enum|enum_type }} = {{ enum|enum_value }};
{% endfor %}

// Functions
{% for command in feature_set.commands %}
export fn {{ command.name }}({{ command|params }}) {{ command.proto.ret|type }};
{% endfor %}
