#define Prg new Ast::Program
#define Func new Ast::FuncStmt

#define Num(n) new Ast::NumExpr(n)
#define Var(v) new Ast::IdentExpr(v)

#define Add new Ast::AddExpr
#define And new Ast::AndExpr
#define Or new Ast::OrExpr
#define Xor new Ast::XorExpr
#define LessThan new Ast::LessThanExpr

#define Assign new Ast::AssignExpr
#define Block new Ast::BlockStmt
#define Print new Ast::PrintStmt
#define Call new Ast::CallExpr
#define If new Ast::IfStmt
#define While new Ast::WhileStmt

#define ParamByVal(p) new Ast::IdentExpr(p)
#define ParamByRef(p) new Ast::IdentExpr(p)
