import 'package:equatable/equatable.dart';

class CaptureState extends Equatable {
 const CaptureState();

  @override
  // TODO: implement props
  List<Object> get props => [];
  
}

class EmptyState extends CaptureState {}

class Captured extends CaptureState {}

class ErrorCapturing extends CaptureState {}