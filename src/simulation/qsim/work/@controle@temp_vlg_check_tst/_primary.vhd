library verilog;
use verilog.vl_types.all;
entity ControleTemp_vlg_check_tst is
    port(
        acionamento     : in     vl_logic;
        display         : in     vl_logic_vector(3 downto 0);
        segmentos       : in     vl_logic_vector(6 downto 0);
        sol_dp_bug      : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end ControleTemp_vlg_check_tst;
