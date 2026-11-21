# m <schluessel> [argumente]: uebersetzte Meldung ausgeben
MSGS="${MSGS:-/usr/local/lib/spiralos/msgs.tsv}"
m() {
  _k="$1"; shift
  _l=$(printf %s "${LANGUAGE:-${LANG:-en}}" | cut -c1-2)
  _f=$(awk -F'\t' -v k="$_k" -v l="$_l" 'NR==1{for(i=2;i<=NF;i++)if($i==l)c=i;if(!c)c=2;next} $1==k{print $c;exit}' "$MSGS")
  [ -n "$_f" ] || _f="$_k"
  printf "$_f\n" "$@"
}
