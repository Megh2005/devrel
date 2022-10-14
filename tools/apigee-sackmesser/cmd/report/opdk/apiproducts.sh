#!/bin/bash

# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# <http://www.apache.org/licenses/LICENSE-2.0>
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

echo "<h3>API Products</h3>" >> "$report_html"

mkdir -p "$export_folder/$organization/config/resources/edge/env/$environment/api-products"

sackmesser list "organizations/$organization/apiproducts"| jq -r -c '.[]|.' | while read -r apiProductName; do
        sackmesser list "organizations/$organization/apiproducts/$apiProductName" > "$export_folder/$organization/config/resources/edge/env/$environment/api-products/$apiProductName".json
        elem_count=$(jq '.entries? | length' "$export_folder/$organization/config/resources/edge/env/$environment/api-products/$apiProductName".json)
    done

if ls "$export_folder/$organization/config/resources/edge/env/$environment/api-products"/*.json 1> /dev/null 2>&1; then
    jq -n '[inputs]' "$export_folder/$organization/config/resources/edge/env/$environment/api-products"/*.json > "$export_folder/$organization/config/resources/edge/env/$environment/api-products".json
fi

echo "<div><table id=\"ts-lint\" data-toggle=\"table\" class=\"table\">" >> "$report_html"
echo "<thead class=\"thead-dark\"><tr>" >> "$report_html"
echo "<th data-sortable=\"true\" data-field=\"id\">Product Name</th>" >> "$report_html"
echo "<th data-sortable=\"true\" data-field=\"envs\">Environments</th>" >> "$report_html"
echo "<th data-sortable=\"true\" data-field=\"proxies\">Proxies</th>" >> "$report_html"
echo "<th data-sortable=\"true\" data-field=\"enabled\">Aproval Type</th>" >> "$report_html"
echo "</tr></thead>" >> "$report_html"

echo "<tbody class=\"mdc-data-table__content\">" >> "$report_html"

jq -c '.[]' "$export_folder/$organization/config/resources/edge/env/$environment/api-products".json | while read i; do 
    apiProductName=$(echo "$i" | jq -r '.name')
    envs=$(echo "$i" | jq -r '.environments[]')
    proxies=$(echo "$i" | jq -r '.proxies[]')
    approvalType=$(echo "$i" | jq -r '.approvalType')

    echo "<tr class=\"$highlightclass\">"  >> "$report_html"
    echo "<td>$apiProductName</td>"  >> "$report_html"
    echo "<td>"$envs"</td>"  >> "$report_html"
    echo "<td>$proxies</td>" >> "$report_html"
    echo "<td>$approvalType</td>" >> "$report_html"
    echo "</tr>"  >> "$report_html"
done

echo "</tbody></table></div>" >> "$report_html"