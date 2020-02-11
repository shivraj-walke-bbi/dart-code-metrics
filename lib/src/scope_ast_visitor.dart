import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:dart_code_metrics/src/cyclomatic_complexity/models/scoped_declaration.dart';

class ScopeAstVisitor extends RecursiveAstVisitor<Object> {
  final _declarations = <ScopedDeclaration>[];

  SimpleIdentifier _declarationIdentifier;

  Iterable<ScopedDeclaration> get declarations => _declarations;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    _declarationIdentifier = node.name;
    super.visitClassDeclaration(node);
    _declarationIdentifier = null;
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    _registerDeclaration(node);
    super.visitFunctionDeclaration(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    if (node.body is! EmptyFunctionBody) {
      _registerDeclaration(node);
    }
    super.visitMethodDeclaration(node);
  }

  @override
  void visitMixinDeclaration(MixinDeclaration node) {
    _declarationIdentifier = node.name;
    super.visitMixinDeclaration(node);
    _declarationIdentifier = null;
  }

  void _registerDeclaration(Declaration node) {
    _declarations.add(ScopedDeclaration(node, _declarationIdentifier));
  }
}
