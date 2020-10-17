$String_ = ("0;1;@(0)*25;1;1;0 4;9;12;@(1)*23;13;9;8;7 6;8;10;@(2)*23;11;8;9;5 4;9;12;14;@(1)*21;15;13;9;8;7 " + 
            "6;8;10;@(2)*24;0;11;5 4;10;@(0)*26;4;7 6;5;0;0;@(1)*22;0;0;6;5 4;7;0;4;10;@(2)*8;22;23;@(2)*10;1" + 
            "1;5;0;4;7 6;5;0;6;5;16;17;0;16;17;0;16;17;24;25;@(1)*10;13;7;0;6;5 4;7;0;4;7;18;0;19;18;0;19;18;" + 
            "0;24;23;@(2)*10;11;5;0;4;7 @(10)*3;@(15)*24;@(10)*3 6;5;0;6;5;@(0)*8;24;25;@(1)*10;13;7;0;6;5 4;" + 
            "7;0;4;7;16;17;0;16;17;0;16;17;24;23;@(2)*10;11;5;0;4;7 6;5;0;6;5;18;0;19;18;0;19;18;0;24;25;@(1)" + 
            "*10;13;7;0;6;5 4;7;0;4;7;@(0)*8;24;23;@(2)*10;11;5;0;4;7 6;5;0;6;5;16;17;0;16;17;0;16;17;24;25;@" + 
            "(1)*10;13;7;0;6;5 4;7;0;4;7;18;0;19;18;0;19;18;0;24;23;@(2)*10;11;5;0;4;7 6;5;0;6;5;@(0)*8;24;25" + 
            ";@(1)*10;13;7;0;6;5 4;7;0;4;7;16;17;0;16;17;0;16;17;24;23;@(2)*10;11;5;0;4;7 6;5;0;6;5;18;0;19;1" + 
            "8;0;19;18;0;24;25;@(1)*10;13;7;0;6;5 4;7;0;4;7;16;17;0;16;17;0;16;17;24;23;@(2)*10;11;5;0;4;7 6;" + 
            "5;0;6;12;@(1)*8;26;25;@(1)*10;13;7;0;6;5 4;7;0;4;10;;@(2)*20;;11;5;0;4;7 6;5;0;6;12;@(1)*7;20;8;" + 
            "20;20;8;20;@(1)*7;13;7;0;6;5 4;7;0;4;10;@(2)*7;20;@(2)*4;20;@(2)*7;11;5;0;4;7 6;5;0;6;12;@(1)*7;" + 
            "20;0;0;0;0;20;@(1)*7;13;7;0;6;5 4;7;0;4;10;@(2)*7;20;0;0;0;0;20;@(2)*7;11;5;0;4;7 6;5;0;6;12;1;1" + 
            ";1;21;20;8;20;20;0;0;0;0;20;20;8;20;21;1;1;1;13;7;0;6;5 4;7;0;4;10;2;2;2;21;2;2;2;2;0;0;0;0;2;2;" + 
            "2;2;21;2;2;2;11;5;0;4;7 6;5;0;6;12;1;1;1;21;@(0)*12;21;1;1;1;13;7;0;6;5 4;7;0;4;10;2;2;2;21;@(2)" + 
            "*12;21;2;2;2;11;5;0;4;7 6;5;0;6;12;1;1;20;21;20;8;20;20;8;20;20;8;20;20;8;20;21;20;1;1;13;7;0;6;" + 
            "5 4;7;0;4;10;2;2;20;@(2)*14;20;2;2;11;5;0;4;7 6;5;0;6;12;1;1;20;@(0)*14;20;1;1;13;7;0;6;5 4;7;0;" + 
            "0;@(2)*22;0;0;13;7 6;12;@(0)*25;13;9;5 4;9;12;@(1)*23;13;9;8;7 6;8;10;@(2)*23;11;8;10;0 0;11;12;" + 
            "14;@(1)*21;15;13;10;0;0 0;0;@(2)*25;0;0;0") -Split " " | % { "@($_)" }

$Fore_   = (("@(10)*30 10;12;@(10)*25;12;12;10 10;@(12)*28;10 10;12;12;@(15)*23;12;10;12;10 10;12;@(10)*28 @(1" + 
            "0)*30 {0} {0} {0} {0} {0} {0} {0} {0} {0} {0} {0} {0} {0} {0} {0} {0} {1} {1} {1} {1} {2} {2} {2" + 
            "} {2} {2} {2} {2} @(10)*3;@(15)*24;@(10)*3 @(10)*28;12;10 10;12;@(10)*25;12;12;10 10;@(12)*27;10" +
            ";10 10;10;12;@(15)*23;12;10;10;10 @(10)*30") -f "@(10)*3;@(15)*24;@(10)*3",("@(10)*3;@(15)*9;@(1" +
            "0)*6;@(15)*9;@(10)*3"),"@(10)*3;@(15)*5;@(10)*14;@(15)*5;@(10)*3" ) -Split " " | % { "@($_)" }

$Back_   = (("{0} {0} {0} {0} {0} {0} {0} {1} {1} {2} {2} {1} {1} {2} {2} {1} {1} {2} {2} {1} {1} @(0)*4;@(15" + 
            ")*22;@(0)*4 {3} @(0)*4;@(12)*8;@(0)*6;@(12)*8;@(0)*4 @(0)*4;@(12)*8;@(0)*6;@(12)*8;@(0)*4 {3} @(" + 
            "0)*4;@(15)*4;@(0)*14;@(15)*4;@(0)*4 @(0)*4;@(12)*4;@(0)*14;@(12)*4;@(0)*4 @(0)*4;@(12)*4;@(0)*14" + 
            ";@(12)*4;@(0)*4 @(0)*4;@(15)*4;@(0)*14;@(15)*4;@(0)*4 @(0)*4;@(15)*3;@(0)*16;@(15)*3;@(0)*4 @(0)" + 
            "*4;@(12)*3;@(0)*16;@(12)*3;@(0)*4 @(0)*4;@(12)*3;@(0)*16;@(12)*3;@(0)*4 {0} {0} {0} {0} {0} {0}") -f 
            "@(0)*30","@(0)*4;@(9)*10;@(12)*12;@(0)*4","@(0)*4;@(9)*10;@(15)*12;@(0)*4",("@(0)*4;@(15)*8;@(0)" + 
            "*6;@(15)*8;@(0)*4")) -Split " " | % { "@($_)" }
