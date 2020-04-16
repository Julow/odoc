
(* Example usage of these:

$ dune utop src/xref2/test/lib
utop # open Odoc_xref2;;
utop # open Odoc_xref_test;;
utop # let test_data = "module type M = sig type t end module N : M type u = N.t";;
utop # let id, docs, sg = Common.model_of_string test_data;;
utop # let env = Env.open_signature sg Env.empty;;
utop # let unit = Common.my_compilation_unit id docs sg;
utop # Common.resolve unit
utop # Resolve.signature Env.empty sg

*)


let _ = Toploop.set_paths ()

let cmti_of_string s =
    Odoc_xref2.Tools.reset_cache ();
    let env = Compmisc.initial_env () in
    let l = Lexing.from_string s in
    let p = Parse.interface l in
    Typemod.type_interface
#if OCAML_MAJOR = 4 && OCAML_MINOR < 09
    ""
#endif
    env p;;

let cmt_of_string s =
    let env = Compmisc.initial_env () in
    let l = Lexing.from_string s in
    let p = Parse.implementation l in
    Typemod.type_implementation "" "" "" env p

let root_of_compilation_unit ~package ~hidden ~module_name ~digest =
  let file_representation : Odoc_model.Root.Odoc_file.t =
  Odoc_model.Root.Odoc_file.create_unit ~force_hidden:hidden module_name in
  {Odoc_model.Root.package; file = file_representation; digest}

let root = 
    root_of_compilation_unit
        ~package:"nopackage"
        ~hidden:false
        ~module_name:"Root"
        ~digest:"nodigest"

let root_with_name = `Root (root, Odoc_model.Names.UnitName.of_string "Root")

let root_identifier = `Identifier root_with_name

let root_module name = `Module (root_with_name, Odoc_model.Names.ModuleName.of_string name)

let root_pp fmt (_ : Odoc_model.Root.t) = Format.fprintf fmt "Common.root"

let _quoted fmt_a fmt a = Format.fprintf fmt "\"%a\"" fmt_a a
let _quoted_str a_to_str fmt a = Format.fprintf fmt "%S" (a_to_str a)

let unit_name_pp = _quoted_str Odoc_model.Names.UnitName.to_string
let value_name_pp = _quoted_str Odoc_model.Names.ValueName.to_string
let module_name_pp = _quoted Odoc_model.Names.ModuleName.fmt
let module_type_name_pp = _quoted Odoc_model.Names.ModuleTypeName.fmt
let type_name_pp = _quoted Odoc_model.Names.TypeName.fmt
let parameter_name_pp = _quoted Odoc_model.Names.ParameterName.fmt
let exception_name_pp = _quoted_str Odoc_model.Names.ExceptionName.to_string
let field_name_pp = _quoted_str Odoc_model.Names.FieldName.to_string

let model_of_string str = 
    let cmti = cmti_of_string str in
    Odoc_loader__Cmti.read_interface root "Root" cmti

let model_of_string_impl str =
    let (cmt,_) = cmt_of_string str in
    Odoc_loader__Cmt.read_implementation root "Root" cmt

let signature_of_mli_string str =
    Odoc_xref2.Ident.reset ();
    let _, _, sg = model_of_string str in
    sg

let string_of_file f =
    let ic = open_in f in
    let buffer = Buffer.create 100 in
    let rec loop () =
        try
            Buffer.add_channel buffer ic 1024;
            loop ()
        with End_of_file ->
            ()
    in loop ();
    close_in ic;
    Buffer.contents buffer

let file_of_string ~filename str =
    let oc = open_out filename in
    Printf.fprintf oc "%s%!" str;
    close_out oc

let list_files path =
    Sys.readdir path |> Array.to_list

module Ident = Ident

module LangUtils = struct

    module Lens = struct
        open Odoc_model

        type ('a, 'b) lens =
            { get : 'a -> 'b
            ; set : 'b -> 'a -> 'a }

        type ('a, 'b) prism =
            { preview : 'a -> 'b option
            ; review : 'b -> 'a }

        let option : ('a option, 'a) prism =
            let preview = function | Some x -> Some x | None -> None in
            let review = function x -> Some x in
            {preview; review}
    
        let compose : ('a, 'b) lens -> ('b, 'c) lens -> ('a, 'c) lens =
            fun x y ->
                let get z = y.get (x.get z) in
                let set a z = x.set (y.set a (x.get z)) z in
                {get; set}

        let compose_prism : ('a, 'b) lens -> ('b, 'c) prism -> ('a, 'c) lens =
            fun x y ->
                let get z = x.get z |> y.preview |> function | Some x -> x | None -> raise Not_found in
                let set a z = x.set (y.review a) z in
                {get; set}

        let fst : ('a * 'b, 'a) lens =
            let get (x,_) = x in
            let set a (_, y) = (a, y) in
            {get; set}

        let snd : ('a * 'b, 'b) lens =
            let get (_, y) = y in
            let set a (x, _) = (x, a) in
            {get; set}
 
        let (|--) = compose

        let (|-~) = compose_prism

        let get lens x = lens.get x
        let set lens y x = lens.set y x

        let name_of_id = Paths.Identifier.name

        module Signature = struct
            open Lang.Signature
            let module_ : string -> (t, Lang.Module.t) lens = fun name ->
                let module M = Lang.Module in
                let rec get = function
                    | [] -> raise Not_found
                    | (Module (_r,m'))::_xs when name_of_id m'.M.id = name ->
                        m'
                    | _::xs -> get xs
                in
                let set m =
                    let rec inner = function
                        | [] -> raise Not_found
                        | (Module (r, m'))::xs when name_of_id m'.M.id = name ->
                            (Module (r, m)::xs)
                        | x::xs -> x :: inner xs
                    in inner
                in
                { get; set }

            let module_type : string -> (t, Lang.ModuleType.t) lens = fun name ->
                let module MT = Lang.ModuleType in
                let rec get = function
                    | [] -> raise Not_found
                    | (ModuleType m')::_xs when name_of_id m'.MT.id = name ->
                        m'
                    | _::xs -> get xs
                in
                let set m =
                    let rec inner = function
                        | [] -> raise Not_found
                        | (ModuleType m')::xs when name_of_id m'.MT.id = name ->
                            (ModuleType m::xs)
                        | x::xs -> x :: inner xs
                    in inner
                in
                { get; set }

            let type_ : string -> (t, Lang.TypeDecl.t) lens = fun name ->
                let module T = Lang.TypeDecl in
                let rec get = function
                    | [] -> raise Not_found
                    | (Type (_,t'))::_xs when name_of_id t'.T.id = name ->
                        t'
                    | _::xs -> get xs
                in
                let set t =
                    let rec inner = function
                        | [] -> raise Not_found
                        | (Type (r,t'))::xs when name_of_id t'.T.id = name ->
                            (Type (r,t))::xs
                        | x::xs -> x :: inner xs
                    in inner
                in
                { get; set }

            let value : string -> (t, Lang.Value.t) lens = fun name ->
                let module V = Lang.Value in
                let rec get = function
                    | [] -> raise Not_found
                    | (Value v) ::_xs when name_of_id v.V.id = name ->
                        v
                    | _::xs -> get xs
                in
                let set v =
                    let rec inner = function
                        | [] -> raise Not_found
                        | (Value v') :: xs when name_of_id v'.V.id = name ->
                            (Value v)::xs
                        | x::xs -> x :: inner xs
                    in inner
                in
                { get; set }
            end

            module Module = struct
                open Lang.Module

                let id : (t, Paths.Identifier.Module.t) lens =
                    let get m = m.id in
                    let set id t = {t with id} in
                    {get; set}

                let type_ : (t, decl) lens =
                    let get m = m.type_ in
                    let set type_ m = {m with type_} in
                    {get; set}
                
                let decl_moduletype : (decl, Lang.ModuleType.expr) prism =
                    let review x = ModuleType x in
                    let preview = function | ModuleType x -> Some x | _ -> None in
                    {review; preview}

                let expansion : (t, expansion option) lens =
                    let get m = m.expansion in
                    let set expansion t = {t with expansion} in
                    {get; set}
                
                let expansion_signature : (expansion, Lang.Signature.t) prism =
                    let review x = Signature x in
                    let preview = function | Signature x -> Some x | _ -> None in
                    {review; preview}
            end

            module ModuleType = struct
                open Lang.ModuleType

                let id : (t, Paths.Identifier.ModuleType.t) lens =
                    let get mt = mt.id in
                    let set id mt = {mt with id} in
                    {get; set}

                let expr : (t, expr option) lens =
                    let get mt = mt.expr in
                    let set expr mt = {mt with expr} in
                    {get; set}

                let expr_signature : (expr, Lang.Signature.t) prism =
                    let review x = Signature x in
                    let preview = function | Signature x -> Some x | _ -> None in
                    {review; preview}

                let expr_functor : (expr, (Lang.FunctorParameter.t * expr)) prism =
                    let review (x,y) = Functor (x,y) in
                    let preview = function | Functor (x,y) -> Some (x,y) | _ -> None in
                    {review; preview}
            end

            module FunctorParameter = struct
                    open Lang.FunctorParameter

                let id : (parameter, Paths.Identifier.Module.t) lens =
                    let get mt = mt.id in
                    let set id mt = {mt with id} in
                    {get; set}

                let expr : (parameter, Lang.ModuleType.expr) lens =
                    let get mt = mt.expr in
                    let set expr mt = {mt with expr} in
                    {get; set}

                let named : (t, parameter) prism =
                  let review x = Named x in
                  let preview = function | Unit -> None | Named p -> Some p in
                  {review; preview}
            end 

            module TypeDecl = struct
                open Lang.TypeDecl

                module Equation = struct
                    open Equation

                    let params : (t, param list) lens =
                        let get t = t.params in
                        let set params t = {t with params} in
                        { get; set }

                    let manifest : (t, Lang.TypeExpr.t option) lens =
                        let get t = t.manifest in
                        let set manifest t = {t with manifest} in
                        { get; set }
                end

                let id : (t, Paths.Identifier.Type.t) lens =
                    let get t = t.id in
                    let set id t = {t with id} in
                    { get; set }
                
                let equation : (t, Lang.TypeDecl.Equation.t) lens =
                    let get t = t.equation in
                    let set equation t = {t with equation} in
                    { get; set }
                
                let representation : (t, Representation.t option) lens =
                    let get t = t.representation in
                    let set representation t = {t with representation} in
                    { get; set }                    
            end
        
            module TypeExpr = struct
                open Lang.TypeExpr

                let constr : (t, (Odoc_model.Paths.Path.Type.t * t list)) prism =
                    let review (x,y) = Constr (x,y) in
                    let preview = function | Constr (x,y) -> Some (x,y) | _ -> None in
                    {review; preview}

            end

    end

    let test =
        let open Lens in
        Signature.type_ "t" |-- TypeDecl.equation |-- TypeDecl.Equation.manifest


    module Lookup = struct
        let module_from_sig : Odoc_model.Lang.Signature.t -> string -> Odoc_model.Lang.Module.t =
            fun sg mname ->
                let rec inner = function
                    | Odoc_model.Lang.Signature.Module (_, m) :: rest -> begin
                        let id = m.Odoc_model.Lang.Module.id in
                        match id with
                        | `Module (_, mname') ->
                            if Odoc_model.Names.ModuleName.to_string mname' = mname
                            then m
                            else inner rest
                        | _ -> inner rest
                        end
                    | _::rest -> 
                        Format.fprintf Format.std_formatter "Found somethine else\n%!";                   
                        inner rest
                    | _ -> raise Not_found
                in 
                inner sg
    end

    let sig_of_module : Odoc_model.Lang.Module.t -> Odoc_model.Lang.Signature.t =
        let open Odoc_model.Lang in
        fun x ->
            match x.type_ with
            | Module.ModuleType ModuleType.Signature s -> s
            | _ -> raise Not_found

    module Fmt = struct
        open Odoc_model.Lang

        let identifier ppf i =
            Format.fprintf ppf "%a"
                Odoc_xref2.Component.Fmt.model_identifier
                (i :> Odoc_model.Paths.Identifier.t)

        let rec signature ppf sg =
            let open Signature in
            Format.fprintf ppf "@[<v>";
            List.iter (function
                | Module (_,m) ->
                    Format.fprintf ppf
                        "@[<v 2>module %a@]@,"
                        module_ m
                | ModuleType mt ->
                    Format.fprintf ppf
                        "@[<v 2>module type %a@]@,"
                        module_type mt
                | Type (_,t) ->
                    Format.fprintf ppf
                        "@[<v 2>type %a@]@," type_decl t
                | _ ->
                    Format.fprintf ppf
                        "@[<v 2>unhandled signature@]@,") sg;
            Format.fprintf ppf "@]"

        and module_decl ppf d =
            let open Module in
            match d with
            | Alias p ->
                Format.fprintf ppf "= %a" path (p :> Odoc_model.Paths.Path.t)
            | ModuleType mt ->
                Format.fprintf ppf ": %a" module_type_expr mt

        and module_ ppf m =
            Format.fprintf ppf "%a %a" identifier m.id module_decl m.type_

        and module_type ppf mt =
            match mt.expr with
            | Some x -> Format.fprintf ppf "%a = %a" identifier mt.id module_type_expr x
            | None -> Format.fprintf ppf "%a" identifier mt.id

        and module_type_expr ppf mt =
            let open ModuleType in
            match mt with
            | Path p -> path ppf (p :> Odoc_model.Paths.Path.t)
            | Signature sg -> Format.fprintf ppf "sig@,@[<v 2>%a@]end" signature sg
            | With (expr,subs) -> Format.fprintf ppf "%a with [%a]" module_type_expr expr substitution_list subs
            | Functor (arg, res) -> Format.fprintf ppf "(%a) -> %a" functor_parameter arg module_type_expr res
            | _ -> Format.fprintf ppf "unhandled module_type_expr"

        and functor_parameter ppf x =
            match x with
            | Unit -> ()
            | Named x -> Format.fprintf ppf "%a" functor_parameter_parameter x

        and functor_parameter_parameter ppf x =
            Format.fprintf ppf "%a : %a" identifier x.FunctorParameter.id module_type_expr x.FunctorParameter.expr

        and type_equation ppf t =
            match t.TypeDecl.Equation.manifest with
            | Some m -> Format.fprintf ppf " = %a" type_expr m
            | None -> ()

        and type_decl ppf t =
            let open TypeDecl in
            Format.fprintf ppf "%a%a" identifier t.id type_equation t.equation

        and substitution ppf t =
            let open ModuleType in
            match t with
            | ModuleEq (frag, decl) ->
                Format.fprintf ppf "%a = %a" model_fragment (frag :> Odoc_model.Paths.Fragment.t) module_decl decl
            | ModuleSubst (frag, mpath) ->
                Format.fprintf ppf "%a := %a" model_fragment (frag :> Odoc_model.Paths.Fragment.t) path (mpath :> Odoc_model.Paths.Path.t)
            | TypeEq (frag, decl) ->
                Format.fprintf ppf "%a%a" model_fragment (frag :> Odoc_model.Paths.Fragment.t) type_equation decl
            | TypeSubst (frag, decl) ->
                Format.fprintf ppf "%a:%a" model_fragment (frag :> Odoc_model.Paths.Fragment.t) type_equation decl


        and substitution_list ppf l =
            match l with
            | sub :: (_ :: _) as subs -> Format.fprintf ppf "%a; %a" substitution sub substitution_list subs
            | sub :: [] -> Format.fprintf ppf "%a" substitution sub
            | [] -> ()

        and type_expr ppf e =
            let open TypeExpr in
            match e with
            | Var x -> Format.fprintf ppf "%s" x
            | Constr (p,_args) -> path ppf (p :> Odoc_model.Paths.Path.t)
            | _ -> Format.fprintf ppf "unhandled type_expr"

        and resolved_path : Format.formatter -> Odoc_model.Paths.Path.Resolved.t -> unit = fun ppf p ->
            let cast p = (p :> Odoc_model.Paths.Path.Resolved.t) in 
            match p with
            | `Apply (p1, p2) -> Format.fprintf ppf "%a(%a)" resolved_path (cast p1) path (p2 :> Odoc_model.Paths.Path.t)
            | `Identifier p -> Format.fprintf ppf "global(%a)" identifier p
            | `Alias (path, realpath) -> Format.fprintf ppf "(%a -> %a)" resolved_path (cast path) resolved_path (cast realpath)
            | `Subst (modty, m) -> Format.fprintf ppf "(%a subst-> %a)" resolved_path (cast modty) resolved_path (cast m)
            | `Module (p, m) -> Format.fprintf ppf "%a.%s" resolved_path (cast p) (Odoc_model.Names.ModuleName.to_string m)
            | `ModuleType (p, mt) -> Format.fprintf ppf "%a.%s" resolved_path (cast p) (Odoc_model.Names.ModuleTypeName.to_string mt)
            | `Type (p, t) -> Format.fprintf ppf "%a.%s" resolved_path (cast p) (Odoc_model.Names.TypeName.to_string t)
            | `OpaqueModule m -> Format.fprintf ppf "opaquemodule(%a)" resolved_path (cast m)
            | `OpaqueModuleType m -> Format.fprintf ppf "opaquemoduletype(%a)" resolved_path (cast m)
            | `SubstT (_, _) 
            | `Class (_, _)
            | `ClassType (_, _)
            | `SubstAlias (_, _)
            | `Hidden _
            | `Canonical _ -> Format.fprintf ppf "unimplemented resolved_path"

        and path : Format.formatter -> Odoc_model.Paths.Path.t -> unit =
            fun ppf (p : Odoc_model.Paths.Path.t) ->
            match p with
            | `Resolved rp -> Format.fprintf ppf "resolved[%a]" resolved_path (rp :> Odoc_model.Paths.Path.Resolved.t)
            | `Root s -> Format.fprintf ppf "%s" s
            | `Forward s -> Format.fprintf ppf "%s" s
            | `Dot (parent,s) -> Format.fprintf ppf "%a.%s" path (parent :> Odoc_model.Paths.Path.t) s
            | `Apply (func,arg) -> Format.fprintf ppf "%a(%a)" path (func :> Odoc_model.Paths.Path.t) path (arg :> Odoc_model.Paths.Path.t)

        and model_fragment ppf (f : Odoc_model.Paths.Fragment.t) =
            match f with
            | `Root -> ()
            | `Resolved rf -> model_resolved_fragment ppf rf
            | `Dot (sg, d) -> Format.fprintf ppf "*%a.%s" model_fragment (sg :> Odoc_model.Paths.Fragment.t) d

        and model_resolved_fragment ppf (f : Odoc_model.Paths.Fragment.Resolved.t) =
            match f with
            | `Root (`Module p) -> Format.fprintf ppf "root_module(%a)" resolved_path (p :> Odoc_model.Paths.Path.Resolved.t) 
            | `Root (`ModuleType p) -> Format.fprintf ppf "root_module_type(%a)" resolved_path (p :> Odoc_model.Paths.Path.Resolved.t) 
            | `Module (sg, m) -> Format.fprintf ppf "%a.%s" model_resolved_fragment (sg :> Odoc_model.Paths.Fragment.Resolved.t) (Odoc_model.Names.ModuleName.to_string m)
            | `Type (sg, m) -> Format.fprintf ppf "%a.%s" model_resolved_fragment (sg :> Odoc_model.Paths.Fragment.Resolved.t) (Odoc_model.Names.TypeName.to_string m)
            | _ -> Format.fprintf ppf "UNIMPLEMENTED model_resolved_fragment"

    end

end

let my_compilation_unit id docs s =
    { Odoc_model.Lang.Compilation_unit.
      id = id
    ; doc = docs
    ; digest = "nodigest"
    ; imports = []
    ; source = None
    ; interface = true
    ; hidden = false
    ; content = Module s
    ; expansion = None
}

let mkenv () =
  Odoc_odoc.Env.create
    ~important_digests:false
    ~directories:(List.map Odoc_odoc.Fs.Directory.of_string
#if OCAML_MAJOR = 4 && OCAML_MINOR >= 08
    (Load_path.get_paths ())
#else
    !Config.load_path
#endif
    ) ~open_modules:[]

let resolve unit =
  let env = mkenv () in
  let resolve_env = Odoc_odoc.Env.build env (`Unit unit) in
  let result = Odoc_xref2.Compile.compile resolve_env unit in
  result


let resolve_from_string s =
    let id, docs, sg = model_of_string s in
    let unit = my_compilation_unit id docs sg in
    resolve unit
