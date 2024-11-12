library verilog;
use verilog.vl_types.all;
entity ControleTemp_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        desativar       : in     vl_logic;
        reset           : in     vl_logic;
        temp_ac         : in     vl_logic_vector(5 downto 0);
        temp_in         : in     vl_logic_vector(5 downto 0);
        tipo            : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end ControleTemp_vlg_sample_tst;
