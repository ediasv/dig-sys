Library IEEE;
use ieee.std_logic_1164.all;


entity DECODER is
    port(
        X0: in std_logic;
        X1: in std_logic;
        X2: in std_logic;
        X3: in std_logic;
        S0: out std_logic;
        S1: out std_logic;
        S2: out std_logic;
        S3: out std_logic;
        S4: out std_logic;
        S5: out std_logic;
        S6: out std_logic
    ); end DECODER;
architecture Hex_Arch of DECODER is
    begin
    
        S0 <= (X3 AND NOT(X2) AND X1 AND X0) 
        OR (X3 AND X2 AND NOT(X1) AND X0) 
        OR (NOT(X3) AND X2 AND NOT(X1) AND NOT(X0))    
        OR (NOT(X3) AND NOT(X2) AND NOT(X1) AND X0);
        
        S1 <= (NOT (X3) AND X2 AND NOT(X1) AND X0) 
        OR (X3 AND X2 AND NOT(X0)) 
        OR (X3 AND X1 AND X0) 
        OR (X2 AND X1 AND NOT(X0));
        
        S2 <= (NOT (X3) AND NOT(X2) AND X1 AND NOT(X0)) 
        OR (X3 AND X2 AND NOT(X0))
        OR (X3 AND X2 AND X1);
        
        S3 <= (NOT (X3) AND NOT(X2) AND NOT(X1) AND X0)
        OR (NOT(X3) AND X2 AND NOT(X1) AND NOT (X0))
        OR (X3 AND NOT(X2) AND X1 AND NOT (X0))
        OR (X2 AND X1 AND X0);
        
        S4 <= (NOT (X3) AND X2 AND NOT(X1))
        OR (NOT (X2) AND NOT (X1) AND X0)
        OR (NOT (X3) AND X0);
        
        S5 <= (X3 AND X2 AND NOT (X1) AND X0) 
        OR (NOT (X3) AND NOT (X2) AND X0)
        OR (NOT (X3) AND X1 AND X0)
        OR (NOT (X3) AND NOT (X2) AND X1);
        
        S6 <= (NOT (X3) AND NOT(X2) AND NOT (X1))
        OR (NOT (X3) AND X2 AND X1 AND X0)
        OR (X3 AND X2 AND NOT(X1) AND NOT (X0));
        
    end Hex_Arch;