// core/src/domain/mod.rs
pub mod entities;
pub mod value_objects;

pub trait Invariant {
    fn validate(&self) -> Result<(), String>;
}
