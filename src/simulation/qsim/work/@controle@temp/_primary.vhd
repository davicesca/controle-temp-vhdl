library verilog;
use verilog.vl_types.all;
entity ControleTemp is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        desativar       : in     vl_logic;
        tipo            : in     vl_logic;
        temp_in         : in     vl_logic_vector(5 downto 0);
        temp_ac         : in     vl_logic_vector(5 downto 0);
        acionamento     : out    vl_logic;
        sol_dp_bug      : out    vl_logic;
        segmentos       : out    vl_logic_vector(6 downto 0);
        display         : out    vl_logic_vector(3 downto 0)
    );
end ControleTemp;
