library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity state_machine is
	Port(
		Q0, Q1, Q2, Q3: in std_logic;	--Current state inputs
		J0, K0, J1, K1, J2, K2, J3, K3: out std_logic --J and K outputs
	);
end state_machine;

architecture gate_level of state_machine is

begin

	--J and K outputs logic (from Karnaugh's maps)
	
	J0 <= ; 
	
	J1 <= ((Q3 AND Q2) OR (NOT(Q2) AND NOT(Q1) AND Q0) OR (Q2 AND NOT(Q1) AND NOT(Q0)));
	
	J2 <= ((NOT(Q3) AND NOT(Q1)) OR (Q3 AND Q1) OR (NOT(Q2) AND (Q1) AND NOT(Q0)));
	
	J3 <= ((Q2 AND NOT(Q1) AND Q0) OR (NOT(Q2) AND Q1 AND Q0));
	
	K0 <= ((Q2 AND Q1) OR (NOT(Q3) AND Q2 AND Q0) OR (Q3 AND NOT(Q2) AND NOT(Q1)));
	
	K1 <= ((NOT(Q2) AND Q1) OR (NOT(Q3) AND Q0));
	
	K2 <= (Q1 OR (NOT(Q3) AND Q0));
	
	K3 <= ((NOT(Q2) AND NOT(Q1) AND NOT(Q0)) OR (Q2 AND Q1 AND Q0));
	

end gate_level;
