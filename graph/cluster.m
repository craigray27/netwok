p=[0.01,0.05,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9];
CL=[0.5737619047619033, 8.452412060301507;
    0.5377619047619039,5.532663316582915;
    0.4489603174603171,4.474422110552764;
    0.3300952380952382,3.7498492462311557
    0.23031349206349236,3.495778894472362
    0.1671071428571428,3.3665829145728643
    0.0922660117660117,3.2274371859296482
    0.05478354978354973,3.1905527638190954
    0.05131818181818181,3.174170854271357
    0.03216161616161615,3.17356783919598
    0.027460345210345197,3.161356783919598
    ];
scatter(p,CL(:,2))
hold on
z=0:0.01:0.9;
xlabel('p')
ylabel('L(p) ')