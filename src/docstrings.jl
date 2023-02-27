const docstring_across =
"""
    across(variable[s], function[s])

Apply functions to multiple variables. If specifiying multiple variables or functions, surround them with a parentheses so that they are recognized as a tuple.

This function should only be called inside of `@mutate()`, `@summarize`, or `@summarise`.

# Arguments
- `variable[s]`: An unquoted variable, or if multiple, an unquoted tuple of variables.
- `function[s]`: A function, or if multiple, a tuple of functions.

# Examples
```jldoctest
julia> df = DataFrame(a = repeat('a':'e'), b = 1:5, c = 11:15);

julia> df2 = @chain df begin
       @summarize(across(b, minimum))
       end
1×1 DataFrame
 Row │ b_minimum 
     │ Int64     
─────┼───────────
   1 │         1

julia> df2 = @chain df begin
       @summarize(across((b,c), (minimum, maximum)))
       end
1×4 DataFrame
 Row │ b_minimum  c_minimum  b_maximum  c_maximum 
     │ Int64      Int64      Int64      Int64     
─────┼────────────────────────────────────────────
   1 │         1         11          5         15

julia> df2 = @chain df begin
       @mutate(across((b,c), (minimum, maximum)))
       end
5×7 DataFrame
 Row │ a     b      c      b_minimum  c_minimum  b_maximum  c_maximum 
     │ Char  Int64  Int64  Int64      Int64      Int64      Int64     
─────┼────────────────────────────────────────────────────────────────
   1 │ a         1     11          1         11          5         15
   2 │ b         2     12          1         11          5         15
   3 │ c         3     13          1         11          5         15
   4 │ d         4     14          1         11          5         15
   5 │ e         5     15          1         11          5         15

julia> df2 = @chain df begin
       @mutate(across((b, startswith("c")), (minimum, maximum)))
       end
5×7 DataFrame
 Row │ a     b      c      b_minimum  c_minimum  b_maximum  c_maximum 
     │ Char  Int64  Int64  Int64      Int64      Int64      Int64     
─────┼────────────────────────────────────────────────────────────────
   1 │ a         1     11          1         11          5         15
   2 │ b         2     12          1         11          5         15
   3 │ c         3     13          1         11          5         15
   4 │ d         4     14          1         11          5         15
   5 │ e         5     15          1         11          5         15

```
"""

const docstring_desc =
"""
    desc(col)

Orders the rows of a DataFrame column in descending order when used inside of `@arrange()`. This function should only be called inside of `@arrange()``.

# Arguments
- `col`: An unquoted column name.

# Examples
```jldoctest
julia> df = DataFrame(a = repeat('a':'e', inner = 2), b = 1:10, c = 11:20);
  
julia> df2 = @chain df begin
       @arrange(a, desc(b))
       end
10×3 DataFrame
 Row │ a     b      c     
     │ Char  Int64  Int64 
─────┼────────────────────
   1 │ a         2     12
   2 │ a         1     11
   3 │ b         4     14
   4 │ b         3     13
   5 │ c         6     16
   6 │ c         5     15
   7 │ d         8     18
   8 │ d         7     17
   9 │ e        10     20
  10 │ e         9     19
```
"""

const docstring_select =
"""
    @select(df, exprs...)

Select variables in a DataFrame.

# Arguments
- `df`: A DataFrame.
- `exprs...`: One or more unquoted variable names separated by commas. Variable names 
         can also be used as their positions in the data, like `x:y`, to select 
         a range of variables.

# Examples
```jldoctest 
julia> df = DataFrame(a = repeat('a':'e'), b = 1:5, c = 11:15);

julia> df2 = @chain df begin
       @select(a,b,c)
       end
5×3 DataFrame
 Row │ a     b      c     
     │ Char  Int64  Int64 
─────┼────────────────────
   1 │ a         1     11
   2 │ b         2     12
   3 │ c         3     13
   4 │ d         4     14
   5 │ e         5     15

julia> df2 = @chain df begin
       @select(a:b)
       end
5×2 DataFrame
 Row │ a     b     
     │ Char  Int64 
─────┼─────────────
   1 │ a         1
   2 │ b         2
   3 │ c         3
   4 │ d         4
   5 │ e         5

julia> df2 = @chain df begin
       @select(1:2)
       end
5×2 DataFrame
 Row │ a     b     
     │ Char  Int64 
─────┼─────────────
   1 │ a         1
   2 │ b         2
   3 │ c         3
   4 │ d         4
   5 │ e         5

julia> df2 = @chain df begin
       @select(-(a:b))
       end
5×1 DataFrame
 Row │ c     
     │ Int64 
─────┼───────
   1 │    11
   2 │    12
   3 │    13
   4 │    14
   5 │    15

julia> df2 = @chain df begin
       @select(contains("b"), startswith("c"))
       end
5×2 DataFrame
 Row │ b      c     
     │ Int64  Int64 
─────┼──────────────
   1 │     1     11
   2 │     2     12
   3 │     3     13
   4 │     4     14
   5 │     5     15

julia> df2 = @chain df begin
       @select(-(1:2))
       end
5×1 DataFrame
 Row │ c     
     │ Int64 
─────┼───────
   1 │    11
   2 │    12
   3 │    13
   4 │    14
   5 │    15

julia> df2 = @chain df begin
       @select(-c)
       end
5×2 DataFrame
 Row │ a     b     
     │ Char  Int64 
─────┼─────────────
   1 │ a         1
   2 │ b         2
   3 │ c         3
   4 │ d         4
   5 │ e         5
```
"""

const docstring_transmute =
"""
    @transmute(df, exprs...)

Create a new DataFrame with only computed columns.

# Arguments
- `df`: A DataFrame.
- `exprs...`: add new columns or replace values of existed columns using
         `new_variable = values` syntax.

# Examples
```jldoctest 
julia> df = DataFrame(a = repeat('a':'e'), b = 1:5, c = 11:15);

julia> df2 = @chain df begin
       @transmute(d = b + c)
       end
5×1 DataFrame
 Row │ d     
     │ Int64 
─────┼───────
   1 │    12
   2 │    14
   3 │    16
   4 │    18
   5 │    20
```
"""

const docstring_rename =
"""
    @rename(df, exprs...)

Change the names of individual column names in a DataFrame. Users can also use `@select()`
to rename and select columns.

# Arguments
- `df`: A DataFrame.
- `exprs...`: Use `new_name = old_name` syntax to rename selected columns.

# Examples
```jldoctest 
julia> df = DataFrame(a = repeat('a':'e'), b = 1:5, c = 11:15);

julia> df2 = @chain df begin
       @rename(d = b, e = c)
       end
5×3 DataFrame
 Row │ a     d      e     
     │ Char  Int64  Int64 
─────┼────────────────────
   1 │ a         1     11
   2 │ b         2     12
   3 │ c         3     13
   4 │ d         4     14
   5 │ e         5     15
```
"""

const docstring_mutate =
"""
    @mutate(df, exprs...)
  
Create new columns as functions of existing columns. The results have the same number of
rows as `df`.

# Arguments
- `df`: A DataFrame.
- `exprs...`: add new columns or replace values of existed columns using
         `new_variable = values` syntax.

# Examples
```jldoctest 
julia> df = DataFrame(a = repeat('a':'e'), b = 1:5, c = 11:15);

julia> df2 = @chain df begin
       @mutate(d = b + c, b_minus_mean_b = b - mean(b))
       end
5×5 DataFrame
 Row │ a     b      c      d      b_minus_mean_b 
     │ Char  Int64  Int64  Int64  Float64        
─────┼───────────────────────────────────────────
   1 │ a         1     11     12            -2.0
   2 │ b         2     12     14            -1.0
   3 │ c         3     13     16             0.0
   4 │ d         4     14     18             1.0
   5 │ e         5     15     20             2.0

julia> df2 = @chain df begin
       @mutate(across((b, c), mean))
       end
5×5 DataFrame
 Row │ a     b      c      b_mean   c_mean  
     │ Char  Int64  Int64  Float64  Float64 
─────┼──────────────────────────────────────
   1 │ a         1     11      3.0     13.0
   2 │ b         2     12      3.0     13.0
   3 │ c         3     13      3.0     13.0
   4 │ d         4     14      3.0     13.0
   5 │ e         5     15      3.0     13.0
```
"""

const docstring_summarize =
"""
    @summarize(df, exprs...)
    @summarise(df, exprs...)

Create a new DataFrame with one row that aggregating all observations from the input DataFrame or GroupedDataFrame. 

# Arguments
- `df`: A DataFrame.
- `exprs...`: a `new_variable = function(old_variable)` pair. `function()` should be an aggregate function that returns a single value. 

# Examples
```jldoctest 
julia> df = DataFrame(a = repeat('a':'e'), b = 1:5, c = 11:15);

julia> df2 = @chain df begin
       @summarize(mean_b = mean(b), median_b = median(b))
       end
1×2 DataFrame
 Row │ mean_b   median_b 
     │ Float64  Float64  
─────┼───────────────────
   1 │     3.0       3.0
  
julia> df2 = @chain df begin
       @summarise(mean_b = mean(b), median_b = median(b))
       end
1×2 DataFrame
 Row │ mean_b   median_b 
     │ Float64  Float64  
─────┼───────────────────
   1 │     3.0       3.0
   
julia> df2 = @chain df begin
       @summarize(across((b,c), (minimum, maximum)))
       end
1×4 DataFrame
 Row │ b_minimum  c_minimum  b_maximum  c_maximum 
     │ Int64      Int64      Int64      Int64     
─────┼────────────────────────────────────────────
   1 │         1         11          5         15
```
"""

const docstring_filter =
"""
    @filter(df, exprs...)

Subset a DataFrame and return a copy of DataFrame where specified conditions are satisfied.

# Arguments
- `df`: A DataFrame.
- `exprs...`: transformation(s) that produce vectors containing `true` or `false`.

# Examples
```jldoctest 
julia> df = DataFrame(a = repeat('a':'e'), b = 1:5, c = 11:15);

julia> df2 = @chain df begin
       @filter(b >= mean(b))
       end
3×3 DataFrame
 Row │ a     b      c     
     │ Char  Int64  Int64 
─────┼────────────────────
   1 │ c         3     13
   2 │ d         4     14
   3 │ e         5     15
```
"""

const docstring_group_by =
"""
    @group_by(df, exprs...)

Return a `GroupedDataFrame` where operations are performed by groups specified by unique 
sets of `cols`.

# Arguments
- `df`: A DataFrame.
- `exprs...`: DataFrame columns to group by or tidy expressions. Can be a single tidy expression or multiple expressions separated by commas.

# Examples
```jldoctest 
julia> df = DataFrame(a = repeat('a':'e'), b = 1:5, c = 11:15);

julia> df2 = @chain df begin
       @group_by(a)
       @summarize(b = mean(b))
       end
5×2 DataFrame
 Row │ a     b       
     │ Char  Float64 
─────┼───────────────
   1 │ a         1.0
   2 │ b         2.0
   3 │ c         3.0
   4 │ d         4.0
   5 │ e         5.0  

julia> df2 = @chain df begin
       @group_by(d = uppercase(a))
       @summarize(b = mean(b))
       end
5×2 DataFrame
 Row │ d     b       
     │ Char  Float64 
─────┼───────────────
   1 │ A         1.0
   2 │ B         2.0
   3 │ C         3.0
   4 │ D         4.0
   5 │ E         5.0
```
"""

const docstring_slice =
"""
    @slice(df, exprs...)

Select, remove or duplicate rows by indexing their integer positions.

# Arguments
- `df`: A DataFrame.
- `exprs...`: integer row values. Use positive values to keep the rows, or negative values to drop. Values provided must be either all positive or all negative, and they must be within the range of DataFrames' row numbers.

# Examples
```jldoctest 
julia> df = DataFrame(a = repeat('a':'e'), b = 1:5, c = 11:15);

julia> df2 = @chain df begin
       @slice(1:5)
       end
5×3 DataFrame
 Row │ a     b      c     
     │ Char  Int64  Int64 
─────┼────────────────────
   1 │ a         1     11
   2 │ b         2     12
   3 │ c         3     13
   4 │ d         4     14
   5 │ e         5     15

julia> df2 = @chain df begin
       @slice(-(1:5))
       end
0×3 DataFrame
 Row │ a     b      c     
     │ Char  Int64  Int64 
─────┴──────────────────── 

julia> df2 = @chain df begin
       @group_by(a)
       @slice(1)
       end
5×3 DataFrame
 Row │ a     b      c     
     │ Char  Int64  Int64 
─────┼────────────────────
   1 │ a         1     11
   2 │ b         2     12
   3 │ c         3     13
   4 │ d         4     14
   5 │ e         5     15
```         
"""

const docstring_arrange =
"""
    @arrange(df, exprs...)

Orders the rows of a DataFrame by the values of specified columns.

# Arguments
- `df`: A DataFrame.
- `exprs...`: Variables from the input DataFrame. Use `desc()` to sort in descending order. Multiple variables can be specified, separated by commas.

# Examples
```jldoctest
julia> df = DataFrame(a = repeat('a':'e', inner = 2), b = 1:10, c = 11:20);
  
julia> df2 = @chain df begin
       @arrange(a)
       end
10×3 DataFrame
 Row │ a     b      c     
     │ Char  Int64  Int64 
─────┼────────────────────
   1 │ a         1     11
   2 │ a         2     12
   3 │ b         3     13
   4 │ b         4     14
   5 │ c         5     15
   6 │ c         6     16
   7 │ d         7     17
   8 │ d         8     18
   9 │ e         9     19
  10 │ e        10     20

julia> df2 = @chain df begin
             @arrange(a, desc(b))
             end
10×3 DataFrame
 Row │ a     b      c     
     │ Char  Int64  Int64 
─────┼────────────────────
   1 │ a         2     12
   2 │ a         1     11
   3 │ b         4     14
   4 │ b         3     13
   5 │ c         6     16
   6 │ c         5     15
   7 │ d         8     18
   8 │ d         7     17
   9 │ e        10     20
  10 │ e         9     19
```
"""