


var tipuesearch = {"pages" : 

{{- $.Scratch.Add "searchindex" slice -}}

{{- range .Site.RegularPages -}}
    {{- $.Scratch.Add "searchindex" (dict "title" .Title  "text" .Plain "url" .Permalink) -}}
{{- end -}}

{{- $.Scratch.Get "searchindex" | jsonify -}}

};

