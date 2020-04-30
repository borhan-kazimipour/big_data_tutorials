#!/bin/bash

# Welcome!
printf "

                                                                                                                                   
                                                                                                                                   
  BBBBBBBBBBBBBBBBB     iiii                           DDDDDDDDDDDDD                                 tttt                            
  B::::::::::::::::B   i::::i                          D::::::::::::DDD                           ttt:::t                            
  B::::::BBBBBB:::::B   iiii                           D:::::::::::::::DD                         t:::::t                            
  BB:::::B     B:::::B                                 DDD:::::DDDDD:::::D                        t:::::t                            
    B::::B     B:::::Biiiiiii    ggggggggg   ggggg       D:::::D    D:::::D  aaaaaaaaaaaaa  ttttttt:::::ttttttt      aaaaaaaaaaaaa   
    B::::B     B:::::Bi:::::i   g:::::::::ggg::::g       D:::::D     D:::::D a::::::::::::a t:::::::::::::::::t      a::::::::::::a  
    B::::BBBBBB:::::B  i::::i  g:::::::::::::::::g       D:::::D     D:::::D aaaaaaaaa:::::at:::::::::::::::::t      aaaaaaaaa:::::a 
    B:::::::::::::BB   i::::i g::::::ggggg::::::gg       D:::::D     D:::::D          a::::atttttt:::::::tttttt               a::::a 
    B::::BBBBBB:::::B  i::::i g:::::g     g:::::g        D:::::D     D:::::D   aaaaaaa:::::a      t:::::t              aaaaaaa:::::a 
    B::::B     B:::::B i::::i g:::::g     g:::::g        D:::::D     D:::::D aa::::::::::::a      t:::::t            aa::::::::::::a 
    B::::B     B:::::B i::::i g:::::g     g:::::g        D:::::D     D:::::Da::::aaaa::::::a      t:::::t           a::::aaaa::::::a 
    B::::B     B:::::B i::::i g::::::g    g:::::g        D:::::D    D:::::Da::::a    a:::::a      t:::::t    tttttta::::a    a:::::a 
  BB:::::BBBBBB::::::Bi::::::ig:::::::ggggg:::::g      DDD:::::DDDDD:::::D a::::a    a:::::a      t::::::tttt:::::ta::::a    a:::::a 
  B:::::::::::::::::B i::::::i g::::::::::::::::g      D:::::::::::::::DD  a:::::aaaa::::::a      tt::::::::::::::ta:::::aaaa::::::a 
  B::::::::::::::::B  i::::::i  gg::::::::::::::g      D::::::::::::DDD     a::::::::::aa:::a       tt:::::::::::tt a::::::::::aa:::a
  BBBBBBBBBBBBBBBBB   iiiiiiii    gggggggg::::::g      DDDDDDDDDDDDD         aaaaaaaaaa  aaaa         ttttttttttt    aaaaaaaaaa  aaaa
                                        g:::::g                                                                                    
                            gggggg      g:::::g                                                                                    
                            g:::::gg   gg:::::g                                                                                    
                             g::::::ggg:::::::g                                                                                    
                              gg:::::::::::::g                                                                                     
                                ggg::::::ggg                                                                                       
                                   gggggg                                                                                          


"
sleep 1

printf """
starting Hadoop ...


"""
bash /home/start-hadoop.sh

printf """
starting HBase ...


"""
bash $HBASE_HOME/bin/start-hbase.sh

printf """
starting Jupyter ...


"""
cd /home
bash /home/start-jupyter.sh