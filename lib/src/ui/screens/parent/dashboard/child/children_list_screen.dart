import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_event.dart';
import '../../../../../blocs/parent/parent_auth_bloc.dart';
import '../../../../../blocs/parent/parent_auth_state.dart';
import '../../../../../config/routes.dart';

class ChildrenListScreen extends StatefulWidget {
  const ChildrenListScreen({super.key});

  @override
  State<ChildrenListScreen> createState() => _ChildrenListScreenState();
}

class _ChildrenListScreenState extends State<ChildrenListScreen> {

  @override
  void initState() {
    super.initState();
    context.read<ParentAuthBloc>().add(ParentChildGetRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: BlocBuilder<ParentAuthBloc, ParentAuthState>(
              builder: (context, state) {
                if (state is ParentChildGetSuccess) {
                  // print("Children count in UI: ${state.children.length}");
                  final children = state.children;
                  if (children.isEmpty) {
                    return const Center(child: Text("No children found."));
                  }
                  return ListView.builder(
                    itemCount: children.length,
                    itemBuilder: (context, index) {
                      final child = children[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(
                                child.firstName.substring(0, 1).toUpperCase()),
                          ),
                          title: Text('${child.firstName} ${child.lastName}'),
                          subtitle: Text('School Level: ${child.schoolLevel}'),
                          trailing: Icon(
                            child.status ? Icons.check_circle : Icons.cancel,
                            color: child.status ? Colors.green : Colors.red,
                          ),
                          onTap: () {
                            // Optionally handle tap.
                          },
                        ),
                      );
                    },
                  );
                } else if (state is ParentChildGetFailure) {
                  return Center(child: Text("Error: ${state.error}"));
                } else {
                  return const Center(child: Text("No data available."));
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                  context, Routes.parentChildRegistrationScreen);
            },
            child: const Text("Register new child"),
          ),
        ],
      ),
    );
  }
}
