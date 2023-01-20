baud_rate = [300 1200 4800 9600 19200 38400 57600 115200];

T_sample_desired_nanosec = 1./(16.*baud_rate) .* 1e9;
T_half_sample_desired_nanosec = T_sample_desired_nanosec./2;

clocks_till_reverse = round(T_half_sample_desired_nanosec./20)












