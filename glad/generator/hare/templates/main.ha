{% set ctx_name = feature_set.name | capitalize %}
// Loader
fn load(name: str) *void = {
    return (1234: uintptr: *void);
};

// Types
{% include 'types/' + spec.name + '.ha' ignore missing with context %}

// Constants
{% for enum in feature_set.enums %}
export def {{ enum.name|no_prefix }}: {{ enum|enum_type }} = {{ enum|enum_value }};
{% endfor %}

// Function pointers
{% for command in feature_set.commands %}
type fp_{{ command.name }} = fn({{ command|params }}) {{ command.proto.ret|type }};
{% endfor %}

// Functions
export fn loadall() void = {
    {% for command in feature_set.commands %}
    const {{ command.name }}: *fp_{{ command.name }} = load("{{ command.name }}"): *fp_{{ command.name }};
    {% endfor %}
};
