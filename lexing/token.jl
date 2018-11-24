module token

    include("../info.jl")

    @enum TokenType begin  # Token Types

    # Basic Token Types
        L_PARN            # (
        R_PARN            # )
        L_BRACKET         # [
        R_BRACKET         # ]
        COMMA             # ,
        DOT               # .
        APOSTROPHE        # '
        QUOTE             # "
        EOL               # End-Of-Line
        INTEGER           # Integer Literal
        DOUBLE            # Decimal Literal
        IDENTIFIER        # Identifier
        STR_LIT           # String Literal
        CHAR_LIT          # Char Literal
        LINE_CONTINUATION # \
        SEMI_COLUMN       # ;

    # Keywords
        AND
        AS
        OR
        IN
        NOT
        FOR
        RETURN
        IF
        WHILE
        FUNC
        NEW
        STRUCT
        END

    # Operators
        ASSIGN_OP         # =
        EQ_OP             # ==
        GREATER_OP        # >
        LESS_OP           # <
        PLUS_OP           # +
        MINUS_OP          # -
        DIVIDE_OP         # /
        MULT_OP           # *
        POW_OP            # ^
        MOD_OP            # %
        DIFF_OP           # !=
        GREATER_EQ        # >=
        LESS_EQ           # <=
        PLUS_EQ           # +=
        MINUS_EQ          # -=
        DIVIDE_EQ         # /=
        MULT_EQ           # *=
        POW_EQ            # ^=
        MOD_EQ            # %=
        MATCH_OP          # =>

    # Other
        OTHER             # Unidentified Tokens

    end

    Tok_Types_Defs = [
                        ("(",  L_PARN),
                        (")",  R_PARN),
                        ("[",  L_BRACKET),
                        ("]",  R_BRACKET),
                        (",",  COMMA),
                        (".",  DOT),
                        ("'",  APOSTROPHE),
                        ("\"", QUOTE),
                        ("\n", EOL),
                        ("\\", LINE_CONTINUATION),
                        (";",  SEMI_COLUMN),
                        ("=",  ASSIGN_OP),
                        ("==", EQ_OP),
                        (">",  GREATER_OP),
                        ("<",  LESS_OP),
                        ("+",  PLUS_OP),
                        ("-",  MINUS_OP),
                        ("/",  DIVIDE_OP),
                        ("*",  MULT_OP),
                        ("^",  POW_OP),
                        ("%",  MOD_OP),
                        ("!=", DIFF_OP),
                        (">=", GREATER_EQ),
                        ("<=", LESS_EQ),
                        ("+=", PLUS_EQ),
                        ("-=", MINUS_EQ),
                        ("/=", DIVIDE_EQ),
                        ("*=", MULT_EQ),
                        ("^=", POW_EQ),
                        ("%=", MOD_EQ)
    ]

    #----------------------------#

    mutable struct Position     # Struct for tokens positions
        line           :: Integer
        start_end_cols :: Tuple{Integer, Integer} 
    end

    struct Token
        value :: String         # Token Value
        type_ :: TokenType      # Token Type
        pos   :: Position       # Attributes : line, col
    end

    mutable struct Opened_Symbs_Status
        opnd_str_lit        :: Bool
        opnd_char_lit       :: Bool
        opnd_paren_amount   :: Integer
        opnd_bracket_amount :: Integer
    end

    #----------------------------#

    keywords_lst  = [
                    
                     ("and", AND),
                     ("as", AS),
                     ("or", OR),
                     ("in", IN),
                     ("not", NOT),
                     ("for", FOR),
                     ("return", RETURN),
                     ("if", IF),
                     ("while", WHILE),
                     ("func", FUNC),
                     ("new", NEW),
                     ("struct", STRUCT),
                     ("for", FOR),
                     ("end", END)
                    
                     ]

end
