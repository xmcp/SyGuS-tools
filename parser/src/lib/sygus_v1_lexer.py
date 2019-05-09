import ply.lex
from .sygus_lexer_base import _SygusLexerBase


# noinspection PyPep8Naming
class SygusV1Lexer(_SygusLexerBase):
    tokens = _SygusLexerBase._tokens
    reserved = _SygusLexerBase._reserved

    reserved['declare-fun'] = 'TK_DECLARE_FUN'
    reserved['set-options'] = 'TK_SET_OPTIONS'
    reserved['declare-primed-var'] = 'TK_DECLARE_PRIMED_VAR'
    reserved['BitVec'] = 'TK_BV'
    reserved['Int'] = 'TK_INT'
    reserved['Bool'] = 'TK_BOOL'
    reserved['Real'] = 'TK_REAL'
    reserved['String'] = 'TK_STRING'
    reserved['Enum'] = 'TK_ENUM'
    reserved['Array'] = 'TK_ARRAY'

    tokens += list(set(reserved.values()))
    tokens.append('TK_DOUBLE_COLON')

    t_TK_DOUBLE_COLON = r'::'

    @ply.lex.TOKEN(_SygusLexerBase._symbol)
    def t_TK_SYMBOL(self, t):
        t.type = self.reserved.get(t.value, 'TK_SYMBOL')
        return t

    def __init__(self):
        super().__init__()