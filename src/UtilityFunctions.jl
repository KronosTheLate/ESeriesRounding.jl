geometric_mean(a::Number, b::Number) = √(a*b)

function find_under_and_over(a::Number, possible_values::Array)
    possible_series_sorted = sort(possible_values)
    i, j = 1, 2
        while !(possible_series_sorted[i] ≤ a ≤ possible_series_sorted[j])
            i+=1; j+=1
        end
    return possible_series_sorted[i], possible_series_sorted[j]
end

function norm_to_between_100_and_1000(val::Number; return_OOM=true)
    power_of_10 = 0.0
    while val > 1000
        val/=10; power_of_10 += 1
    end
    while val < 100
        val*=10; power_of_10 += -1
    end
    if return_OOM
        return val, power_of_10
    else
        return val
    end
end
