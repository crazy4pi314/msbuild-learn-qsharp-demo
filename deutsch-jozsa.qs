// Copyright (c) Sarah Kaiser. All rights reserved.
// Licensed under the MIT License.

namespace Build.DeutschJozsa {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Diagnostics;

    operation ZeroOracle(control : Qubit, target : Qubit) : Unit {
    }

    operation OneOracle(control : Qubit, target : Qubit) : Unit {
        X(target);
    }

    operation IdOracle(control : Qubit, target : Qubit) : Unit {
        CNOT(control, target);
    }

    operation NotOracle(control : Qubit, target : Qubit) : Unit {
        X(control);
        CNOT(control, target);
        X(control);
    }

    operation IsOracleBalanced(
            oracle : ((Qubit, Qubit) => Unit)              
    ) : Bool {
        mutable result = Zero;
        using ((control, target) = (Qubit(), Qubit())) {   
            H(control);                                    
            X(target);
            H(target);

            oracle(control, target);                       

            H(target);                                     
            X(target);

            set result = MResetX(control);                 
        }
        return result == One;
    }

    operation IsNotOracleBalanced(): Bool {
        IsOracleBalanced(NotOracle);
    }

    operation IsZeroOracleBalanced(): Bool {
        IsOracleBalanced(ZeroOracle);
    }
 
    operation RunDeutschJozsaAlgorithm() : Unit {
        EqualityFactB(IsOracleBalanced(ZeroOracle), false, "Test failed for zero oracle."); 
        EqualityFactB(IsOracleBalanced(OneOracle), false, "Test failed for one oracle.");   
        EqualityFactB(IsOracleBalanced(IdOracle), true, "Test failed for id oracle.");
        EqualityFactB(IsOracleBalanced(NotOracle), true, "Test failed for not oracle.");

        Message("All tests passed!");                                                         
    }
}