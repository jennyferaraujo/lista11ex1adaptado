      $set sourceformat"free"

      *>Divis�o de identifica��o do programa
       identification division.
       program-id. "lista11ex1adaptado".
       author. "Jennyfer Araujo".
       installation. "PC".
       date-written. 24/07/2020.
       date-compiled. 24/07/2020.

      *>Divis�o para configura��o do ambiente
       environment division.
       configuration section.
           special-names. decimal-point is comma.

      *>-----Declara��o dos recursos externos
       input-output section.
       file-control.

      *>   Declara��o do arquivo
           select arqTemps assign to "arqTemps.txt"          *>assosiando arquivo l�gico (nome dado ao arquivo dentro do pmg vom o arquivo fisico)
           organization is line sequential                   *>forma de organiza��o dos dados
           lock mode is automatic                            *>tratamento de dead lock - evita perda de dados em ambiemtes multi-usu�rios
           file status is ws-fs-arqTemps.                    *>file status (o status da ultima opera��o)

       i-o-control.

      *>Declara��o de vari�veis
       data division.

      *>----Variaveis de arquivos
       file section.
       fd arqTemps.
       01  fd-temperaturas.
           05 fd-temp                             pic s9(02)v99 value 00.

      *>----Variaveis de trabalho
       working-storage section.

       01 ws-temperaturas occurs 30.
          05 ws-temp                              pic s9(02)v99.

       77 ws-media-temp                           pic s9(02)v99.
       77 ws-temp-total                           pic s9(03)v99.

       77 ws-dia                                  pic 9(02).
       77 ws-ind-temp                             pic 9(02).

       77 ws-sair                                 pic x(01).
       77 ws-fs-arqTemps                          pic 9(02).


      *>----Variaveis para comunica��o entre programas
       linkage section.


      *>----Declara��o de tela
       screen section.


      *>Declara��o do corpo do programa
       procedure division.


           perform inicializa.
           perform processamento.
           perform finaliza.

      *>------------------------------------------------------------------------
      *>  Procedimentos de inicializa��o
      *>------------------------------------------------------------------------
       inicializa section.

      *> arquivos para leitura

          open input arqTemps
          perform varying ws-dia from 1 by 1 until ws-dia > 30
              read arqTemps
              move fd-temperaturas to ws-temperaturas(ws-dia)

          close arqTemps
           .
       inicializa-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  Processamento principal
      *>------------------------------------------------------------------------
       processamento section.

      *>   chamando rotina de calculo da m�dia de temp.
           perform calc-media-temp

      *>    menu do sistema
           perform until ws-sair = "S"
                      or ws-sair = "s"
               display erase

               display "Dia a ser testado: "
               accept ws-dia

               if  ws-dia >= 1
               and ws-dia <= 30 then
                   if ws-temp(ws-dia) > ws-media-temp then
                       display "A temperatura do dia " ws-dia " esta acima da media"
                   else
                   if ws-temp(ws-dia) < ws-media-temp then
                           display "A temperatura do dia " ws-dia " esta abaixo da media"
                   else
                           display "A temperatura esta na media"
                   end-if
                   end-if
               else
                   display "Dia fora do intervalo valido (1 -30)"
               end-if

               display "'T'estar outra temperatura"
               display "'S'air"
               accept ws-sair
           end-perform
           .
       processamento-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  Calculo da m�dia de temperatura
      *>------------------------------------------------------------------------
       calc-media-temp section.

           move 0 to ws-temp-total
           perform varying ws-ind-temp from 1 by 1 until ws-ind-temp > 30
               compute ws-temp-total = ws-temp-total + ws-temp(ws-ind-temp)
           end-perform

           compute ws-media-temp = ws-temp-total/30

           .
       calc-media-temp-exit.
           exit.


      *>------------------------------------------------------------------------
      *>  Finaliza��o
      *>------------------------------------------------------------------------
       finaliza section.
           Stop run
           .
       finaliza-exit.
           exit.

