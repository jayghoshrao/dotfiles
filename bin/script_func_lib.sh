function linspace()
{
# Initialize an empty array
declare -a linspace_array

( [[ -n "$1" ]] && [[ -n "$2" ]] ) || return

# Set the range and number of elements
start="$1"
end="$2"
num_elements="${3:-1}"

# Calculate the step size
step=$(awk -v s="$start" -v e="$end" -v n="$num_elements" 'BEGIN{print (e-s)/(n-1)}')

# Generate the array elements
for ((i = 0; i < num_elements; i++)); do
    value=$(awk -v s="$start" -v i="$i" -v step="$step" 'BEGIN{print s + i * step}')
    linspace_array[$i]=$value
done

# Print the array elements
echo "${linspace_array[@]}"
}
