import 'package:equatable/equatable.dart';

class ProcessState extends Equatable {
  const ProcessState();

  @override
  // TODO: implement props
  List<Object> get props => null;
  
}

class ProcessedSuccessfully extends ProcessState {
  
}

class ErrorProcessing extends ProcessState {
  
}

class NotProcessed extends ProcessState {
  
}