function data_record(rank)

global time_mb;
global time_eq;
global time_matrix;
global time_counter;
global time_total;

global mb_count;
global eq_count;

global total_count;
global cache_count;

avg_cache = cache_count/total_count;

global mb_count_table;
global mb_count_table_ac;
global eq_count_table;
global eq_count_table_ac;


global mb_table;
global eq_table;
global matrix_table;
global counter_table;
global total_table;

global mb_table_ac;
global eq_table_ac;
global matrix_table_ac;
global counter_table_ac;
global total_table_ac;

cd('data');

mb_count_table = [mb_count_table;mb_count - mb_count_table_ac];
eq_count_table = [eq_count_table;eq_count - eq_count_table_ac];

mb_table = [mb_table;time_mb - mb_table_ac(end)];
eq_table = [eq_table;time_eq - eq_table_ac(end)];
matrix_table = [matrix_table;time_matrix - matrix_table_ac(end)];
counter_table = [counter_table;time_counter - counter_table_ac(end)];
total_table = [total_table;time_total - total_table_ac(end)];

mb_table_ac = [mb_table_ac;time_mb];
eq_table_ac = [eq_table_ac;time_eq];
matrix_table_ac = [matrix_table_ac;time_matrix];
counter_table_ac = [counter_table_ac;time_counter];
total_table_ac = [total_table_ac;time_total];

mb_count_table_ac = [mb_count_table_ac;mb_count];
eq_count_table_ac = [eq_count_table_ac;eq_count];

save('data')

cd('..');



end

