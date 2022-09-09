# easy access to fixtures
#
# usage:
#   Fixtures::FurAffinity["view_1234.html"]
module Fixtures
  {% for const_name in run("./read_fixtures").strip.split('\n') %}
    {{ const_name.id }} = {
      {% for file_pairs in run("./read_fixtures", const_name).strip.split('\n') %}
        {% file_name, full_path = file_pairs.split('\u0001') %}
        {{ file_name }} => {{ read_file(full_path) }},
      {% end %}
    }
  {% end %}
end
