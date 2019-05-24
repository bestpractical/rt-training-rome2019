use inc::Module::Install;

RTx     'RT-Training-Rome2019';
license 'gpl_2';
repository 'https://github.com/bestpractical/rt-training-rome2019';

requires_rt '4.2.0';
rt_too_new '4.6.0';

sign;
WriteAll;
